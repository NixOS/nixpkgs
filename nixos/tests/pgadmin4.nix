import ./make-test-python.nix ({ pkgs, lib, ... }:

{
  name = "pgadmin4";
  meta.maintainers = with lib.maintainers; [ mkg20001 gador ];

  nodes = {
    machine = { pkgs, ... }: {

      imports = [ ./common/user-account.nix ];

      environment.systemPackages = with pkgs; [
        wget
        curl
        pgadmin4-desktopmode
      ];

      services.postgresql = {
        enable = true;
        authentication = ''
          host    all             all             localhost               trust
        '';
      };

      services.pgadmin = {
        port = 5051;
        enable = true;
        initialEmail = "bruh@localhost.de";
        initialPasswordFile = pkgs.writeText "pw" "bruh2012!";
      };
    };
    machine2 = { pkgs, ... }: {

      imports = [ ./common/user-account.nix ];

      services.postgresql = {
        enable = true;
      };

      services.pgadmin = {
        enable = true;
        initialEmail = "bruh@localhost.de";
        initialPasswordFile = pkgs.writeText "pw" "bruh2012!";
        minimumPasswordLength = 12;
      };
    };
  };


  testScript = ''
    with subtest("Check pgadmin module"):
      machine.wait_for_unit("postgresql")
      machine.wait_for_unit("pgadmin")
      machine.wait_until_succeeds("curl -sS localhost:5051")
      machine.wait_until_succeeds("curl -sS localhost:5051/login | grep \"<title>pgAdmin 4</title>\" > /dev/null")
      # check for missing support files (css, js etc). Should catch not-generated files during build. See e.g. https://github.com/NixOS/nixpkgs/pull/229184
      machine.succeed("wget -nv --level=1 --spider --recursive localhost:5051/login")
      # test idempotenceny
      machine.systemctl("restart pgadmin.service")
      machine.wait_for_unit("pgadmin")
      machine.wait_until_succeeds("curl -sS localhost:5051")
      machine.wait_until_succeeds("curl -sS localhost:5051/login | grep \"<title>pgAdmin 4</title>\" > /dev/null")

    # pgadmin4 module saves the configuration to /etc/pgadmin/config_system.py
    # pgadmin4-desktopmode tries to read that as well. This normally fails with a PermissionError, as the config file
    # is owned by the user of the pgadmin module. With the check-system-config-dir.patch this will just throw a warning
    # but will continue and not read the file.
    # If we run pgadmin4-desktopmode as root (something one really shouldn't do), it can read the config file and fail,
    # because of the wrong config for desktopmode.
    with subtest("Check pgadmin standalone desktop mode"):
      machine.execute("sudo -u alice pgadmin4 >&2 &", timeout=60)
      machine.wait_until_succeeds("curl -sS localhost:5050")
      machine.wait_until_succeeds("curl -sS localhost:5050/browser/ | grep \"<title>pgAdmin 4</title>\" > /dev/null")
      machine.succeed("wget -nv --level=1 --spider --recursive localhost:5050/browser")

    with subtest("Check pgadmin minimum password length"):
      machine2.wait_for_unit("postgresql")
      machine2.wait_for_console_text("Password must be at least 12 characters long")
  '';
})
