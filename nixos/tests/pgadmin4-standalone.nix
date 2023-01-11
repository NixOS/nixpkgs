import ./make-test-python.nix ({ pkgs, lib, ... }:
  # This is separate from pgadmin4 since we don't want both running at once

  {
    name = "pgadmin4-standalone";
    meta.maintainers = with lib.maintainers; [ mkg20001 ];

    nodes.machine = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        curl
      ];

      services.postgresql = {
        enable = true;

        authentication = ''
          host    all             all             localhost               trust
        '';

        ensureUsers = [
          {
            name = "postgres";
            ensurePermissions = {
              "DATABASE \"postgres\"" = "ALL PRIVILEGES";
            };
          }
        ];
      };

      services.pgadmin = {
        enable = true;
        initialEmail = "bruh@localhost.de";
        initialPasswordFile = pkgs.writeText "pw" "bruh2012!";
      };
    };

    testScript = ''
      machine.wait_for_unit("postgresql")
      machine.wait_for_unit("pgadmin")

      machine.wait_until_succeeds("curl -s localhost:5050")
    '';
  })
