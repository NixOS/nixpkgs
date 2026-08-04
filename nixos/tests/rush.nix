{ pkgs, ... }:
{
  name = "rush";
  meta = { inherit (pkgs.rush.meta) maintainers platforms; };

  nodes = {
    client =
      { ... }:
      {
        nix.settings.extra-experimental-features = [ "nix-command" ];

        environment.etc."profiles/per-user/root/.ssh/id_ed25519" = {
          mode = "0400";
          source = ./initrd-network-ssh/id_ed25519;
        };

        programs.ssh = {
          extraConfig = "IdentityFile /etc/profiles/per-user/%u/.ssh/id_ed25519";
          knownHosts.server.publicKeyFile = ./initrd-network-ssh/ssh_host_ed25519_key.pub;
        };
      };

    server =
      { config, ... }:
      {
        environment.etc."ssh/ssh_host_ed25519_key" = {
          mode = "0400";
          source = ./initrd-network-ssh/ssh_host_ed25519_key;
        };

        nix.settings = {
          extra-experimental-features = [ "nix-command" ];
          trusted-users = [ "test" ];
        };

        programs.rush = {
          enable = true;

          global = ''
            debug 1
            sleep-time 0
          '';

          rules = {
            accounting = ''
              acct on
              clrenv
              keepenv SSH_*
              fall-through
            '';

            nix-ssh-ng = ''
              match $user == "test"
              match $# == 2
              match $0 == "nix-daemon"
              match $1 in ("--help" "--stdio")
              set command = "nix daemon $1"
              chdir "${config.nix.package}/bin"
            '';

            rush = ''
              match $user == "test"
              match $0 in ("rushlast" "rushwho")
              chdir "${config.programs.rush.package}/bin"
            '';
          };
        };

        services.openssh = {
          enable = true;

          extraConfig = ''
            Match User test
              AllowAgentForwarding no
              AllowTcpForwarding no
              PermitTTY no
              PermitTunnel no
              X11Forwarding no
            Match All
          '';
        };

        users = {
          groups.test = { };

          users.test = {
            inherit (config.programs.rush) shell;
            group = "test";
            isSystemUser = true;
            openssh.authorizedKeys.keyFiles = [ ./initrd-network-ssh/id_ed25519.pub ];
          };
        };
      };
  };

  testScript = ''
    start_all()

    with subtest("server-side"):
      server.fail("rush -c 'nix-daemon --help'")
      server.fail("rush -c 'rushlast'")
      server.succeed("su -u test -c 'nix-daemon --help'")
      server.succeed("su -u test -c 'rushlast'")

    with subtest("client-side"):
      server.wait_for_unit("sshd")
      client.fail("nix store info --store 'ssh://test@server'")
      client.succeed("nix store info --store 'ssh-ng://test@server'")
  '';
}
