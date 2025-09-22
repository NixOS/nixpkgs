{
  system ? builtins.currentSystem,
  pkgs ? import ../.. {
    inherit system;
    config = { };
  },
}:

let
  inherit (import ../lib/testing-python.nix { inherit system pkgs; }) makeTest;
in
makeTest {
  name = "oxidized";

  nodes.server =
    { config, pkgs, ... }:
    {
      security.pam.services.sshd.allowNullPassword = true; # the default `UsePam yes` makes this necessary
      services = {
        sshd.enable = true;
        openssh = {
          settings.PermitRootLogin = "yes";
          settings.PermitEmptyPasswords = "yes";
        };
        oxidized = {
          enable = true;
          package = pkgs.oxidized;
          routerDB = pkgs.writeText "oxidized-router.db" ''
            localhost:linuxgeneric:root
          '';
          configFile = pkgs.writeText "oxidized-config.yml" ''
            # vi: ft=yaml
            ---
            extensions:
              oxidized-web:
                load: true
                listen: 127.0.0.1
                port: 8888
                vhosts:
                  - localhost
                  - 127.0.0.1
                  - oxidized
                  - oxidized.example.com
            interval: 3600
            retries: 3
            model: linuxgeneric
            username: root
            source:
              default: csv
              csv:
                file: "/var/lib/oxidized/.config/oxidized/router.db"
                delimiter: !ruby/regexp /:/
                map:
                  name: 0
                  model: 1
                  username: 2
                  password: 3
                vars_map:
                  enable: 4
            input:
              default: ssh
              utf8_encoded: true
            output:
              default: git
              git:
                single_repo:  true
                user: oxidized
                email: oxidized@example.com
                repo: /var/lib/oxidized/git
          '';
        };
      };
      systemd.services.oxidized = {
        stopIfChanged = false;
        environment.HOME = "/var/lib/oxidized";
        environment.APP_ENV = "production";
        serviceConfig = {
          StateDirectory = "oxidized";
          MemoryDenyWriteExecute = false;

          PrivateNetwork = false;
          SystemCallFilter = "@system-service";
        };

        path = [ config.programs.ssh.package ];
      };

    };

  testScript =
    { nodes, ... }:
    ''
      start_all()

      server.wait_for_unit("oxidized.service")

      with subtest("Check if oxidized reports the correct version"):
        server.wait_until_succeeds(("curl --silent --fail --location http://127.0.0.1:8888/ | grep '${nodes.server.services.oxidized.package.version}' >&2"))
      with subtest("Check if oxidized can be accessed with a vhost and reports the correct version"):
        server.wait_until_succeeds(("curl --silent --fail --resolve oxidized:8888:127.0.0.1 --location http://oxidized:8888/ | grep '${nodes.server.services.oxidized.package.version}' >&2"))
      with subtest("Check if oxidized can connect to linuxgeneric model"):
        server.wait_until_succeeds("journalctl -b --grep 'Oxidized::Worker -- Configuration updated for /localhost' -t oxidized")
    '';
}
