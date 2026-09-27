{ pkgs, lib, ... }:
{
  name = "oidentd";
  meta.maintainers = with lib.maintainers; [ h7x4 ];

  nodes = {
    loginbox =
      { pkgs, ... }:
      {
        imports = [ ./common/user-account.nix ];

        users.users.bob.homeMode = "0755";

        virtualisation.vlans = [ 1 ];

        networking = {
          useNetworkd = true;
          useDHCP = false;
        };

        systemd.network.networks."01-eth1" = {
          name = "eth1";
          networkConfig.Address = "10.0.0.1/24";
        };

        services.oidentd = {
          enable = true;
          openFirewall = true;
          extraFlags.debug = true;

          settings = {
            default.default.spoof = false;
            users.bob.default.spoof = true;
          };
        };

        specialisation = {
          withHomeAccess.configuration = {
            services.oidentd.grantHomeDirectoryAccess = true;
          };
        };
      };

    server =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [ netcat ];

        virtualisation.vlans = [ 1 ];

        networking = {
          useNetworkd = true;
          useDHCP = false;
        };

        systemd.network.networks."01-eth1" = {
          name = "eth1";
          networkConfig.Address = "10.0.0.2/24";
        };

        systemd.sockets.sleep-hello = {
          wantedBy = [ "sockets.target" ];
          socketConfig = {
            ListenStream = 8080;
            Accept = true;
          };
        };
        systemd.services."sleep-hello@" = {
          serviceConfig = {
            Type = "simple";
            StandardInput = "socket";
            StandardOutput = "socket";
            StandardError = "journal";

            KillSignal = "USR1";
            SendSIGHUP = false;
          };
          script = ''
            read -r key

            echo "Got connection with key $key, holding line" >&2

            exitprog() {
              echo "Exiting" >&2
              exit 0
            }

            trap exitprog USR1

            while true; do
                sleep 1
            done
          '';
        };

        networking.firewall.allowedTCPPorts = [ 8080 ];
      };
  };

  testScript =
    { nodes }:
    let
      bobConfig = pkgs.writeText "nixos-test-oidentd-bob-config" ''
        global {
          reply "thingamabob"
        }
      '';
    in
    ''
      start_all()

      loginbox.wait_for_unit("oidentd.socket")
      server.wait_for_unit("sleep-hello.socket")

      with subtest("Basic connection"):
        loginbox.execute("sudo -u alice -- nc 10.0.0.2 -p 63000 8080 <<<ALICE1 >&2 &")
        server.wait_for_console_text("Got connection with key ALICE1, holding line")
        server.succeed("nc 10.0.0.1 113 <<<'63000, 8080' | grep alice")
        server.systemctl("stop sleep-hello@*")

      with subtest("Root connection hidden"):
        loginbox.execute("nc 10.0.0.2 -p 63000 8080 <<<ROOT1 >&2 &")
        server.wait_for_console_text("Got connection with key ROOT1, holding line")
        server.succeed("nc 10.0.0.1 113 <<<'63000, 8080' | grep HIDDEN-USER")
        server.systemctl("stop sleep-hello@*")

      loginbox.succeed("sudo -u bob -- install -Dm644 ${bobConfig} /home/bob/.config/oidentd.conf")

      with subtest("Installed user config without home access"):
        loginbox.execute("sudo -u bob -- nc 10.0.0.2 -p 63000 8080 <<<BOB1 >&2 &")
        server.wait_for_console_text("Got connection with key BOB1, holding line")
        server.succeed("nc 10.0.0.1 113 <<<'63000, 8080' | grep -v thingamabob")
        server.systemctl("stop sleep-hello@*")

      loginbox.succeed("/run/current-system/specialisation/withHomeAccess/bin/switch-to-configuration switch")
      loginbox.wait_for_unit("oidentd.socket")

      with subtest("Installed user config with home access"):
        loginbox.execute("sudo -u bob -- nc 10.0.0.2 -p 63000 8080 <<<BOB2 >&2 &")
        server.wait_for_console_text("Got connection with key BOB2, holding line")
        server.succeed("nc 10.0.0.1 113 <<<'63000, 8080' | grep thingamabob")
        server.systemctl("stop sleep-hello@*")
    '';
}
