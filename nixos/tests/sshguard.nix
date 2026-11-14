{
  pkgs,
  lib,
  useNftables,
  ...
}:
{
  name = "sshguard";
  meta.maintainers = with lib.maintainers; [ h7x4 ];

  nodes = {
    server = {
      imports = [ ./common/user-account.nix ];

      virtualisation.vlans = [ 1 ];

      networking = {
        useNetworkd = true;
        useDHCP = false;
        nftables.enable = useNftables;
      };

      systemd.network.networks."01-eth1" = {
        name = "eth1";
        networkConfig.Address = "10.0.0.1/24";
      };

      services.openssh = {
        enable = true;
        # Exempt all machines from the builtin guard system
        settings.PerSourcePenaltyExemptList = "10.0.0.0/24";
      };

      services.sshguard = {
        enable = true;

        # The attacker should be temporarily blocked after the first attack
        attack_threshold = 10;
        # Block the attacker for 1 second
        blocktime = 1;
        # After the second attack, the attacker should be permanently banned
        blacklist_threshold = 20;

        enableInspectableLogStream = true;
      };

      systemd.services.sshguard.environment.SSHGUARD_DEBUG = "1";

      specialisation."socket-activated-ssh".configuration = {
        services.openssh.startWhenNeeded = true;
      };
    };

    client =
      { pkgs, ... }:
      {
        virtualisation.vlans = [ 1 ];

        networking = {
          useNetworkd = true;
          useDHCP = false;
        };

        systemd.network.networks."01-eth1" = {
          name = "eth1";
          networkConfig.Address = "10.0.0.2/24";
        };

        environment.systemPackages = with pkgs; [ sshpass ];

        programs.ssh.extraConfig = ''
          StrictHostKeyChecking no
          ConnectTimeout 10
        '';
      };

    attacker =
      { pkgs, ... }:
      {
        virtualisation.vlans = [ 1 ];

        networking = {
          useNetworkd = true;
          useDHCP = false;
        };

        systemd.network.networks."01-eth1" = {
          name = "eth1";
          networkConfig.Address = "10.0.0.3/24";
        };

        environment.systemPackages = with pkgs; [ sshpass ];

        programs.ssh.extraConfig = ''
          StrictHostKeyChecking no
          ConnectTimeout 10
        '';
      };
  };

  testScript = ''
    start_all()

    server.wait_for_unit("multi-user.target")
    server.wait_for_unit("sshguard-logger.service")
    server.wait_for_unit("sshguard.service")
    server.wait_for_open_port(22)

    def bantest():
      with subtest("Ensure normal login works"):
        client.succeed("sshpass -p foobar ssh alice@10.0.0.1 echo a")
        attacker.succeed("sshpass -p foobar ssh -T alice@10.0.0.1 echo a")

      with subtest("Ensure attacker gets banned"):
        # Attack 1
        attacker.fail("sshpass -p wrong ssh alice@10.0.0.1 echo a")

        server.wait_for_console_text("10.0.0.3: unblocking")

        # Attack 2
        attacker.fail("sshpass -p wrong ssh alice@10.0.0.1 echo a")

        server.wait_for_console_text("blacklist: added 10.0.0.3")
        server.succeed("grep 10.0.0.3 /var/lib/sshguard/blacklist.db")

      with subtest("Ensure normal login still works"):
        client.succeed("sshpass -p foobar ssh alice@10.0.0.1 echo a")

    bantest()

    server.succeed("rm /var/lib/sshguard/blacklist.db")
    server.succeed("/run/current-system/specialisation/socket-activated-ssh/bin/switch-to-configuration switch")

    bantest()
  '';
}
