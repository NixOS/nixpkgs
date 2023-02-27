import ./make-test-python.nix ({ pkgs, lib, ... }:

{
  name = "pgadmin4";
  meta.maintainers = with lib.maintainers; [ mkg20001 gador ];

  nodes.machine = { pkgs, ... }: {

    imports = [ ./common/user-account.nix ];

    environment.systemPackages = with pkgs; [
      curl
      pgadmin4-desktopmode
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
      port = 5051;
      enable = true;
      initialEmail = "bruh@localhost.de";
      initialPasswordFile = pkgs.writeText "pw" "bruh2012!";
    };
  };

  testScript = ''
    with subtest("Check pgadmin module"):
      machine.wait_for_unit("postgresql")
      machine.wait_for_unit("pgadmin")
      machine.wait_until_succeeds("curl -s localhost:5051")
      machine.wait_until_succeeds("curl -s localhost:5051/login | grep \"<title>pgAdmin 4</title>\" > /dev/null")

    # pgadmin4 module saves the configuration to /etc/pgadmin/config_system.py
    # pgadmin4-desktopmode tries to read that as well. This normally fails with a PermissionError, as the config file
    # is owned by the user of the pgadmin module. With the check-system-config-dir.patch this will just throw a warning
    # but will continue and not read the file.
    # If we run pgadmin4-desktopmode as root (something one really shouldn't do), it can read the config file and fail,
    # because of the wrong config for desktopmode.
    with subtest("Check pgadmin standalone desktop mode"):
      machine.execute("sudo -u alice pgadmin4 >&2 &", timeout=60)
      machine.wait_until_succeeds("curl -s localhost:5050")
      machine.wait_until_succeeds("curl -s localhost:5050/browser/ | grep \"<title>pgAdmin 4</title>\" > /dev/null")
  '';
})
