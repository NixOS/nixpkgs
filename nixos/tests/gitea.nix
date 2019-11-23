{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

{
  mysql = makeTest {
    name = "gitea-mysql";
    meta.maintainers = with maintainers; [ aanderse kolaente ];

    machine =
      { config, pkgs, ... }:
      { services.gitea.enable = true;
        services.gitea.database.type = "mysql";
      };

    testScript = ''
      start_all()

      machine.wait_for_unit("gitea.service")
      machine.wait_for_open_port(3000)
      machine.succeed("curl --fail http://localhost:3000/")
    '';
  };

  postgres = makeTest {
    name = "gitea-postgres";
    meta.maintainers = [ maintainers.aanderse ];

    machine =
      { config, pkgs, ... }:
      { services.gitea.enable = true;
        services.gitea.database.type = "postgres";
      };

    testScript = ''
      start_all()

      machine.wait_for_unit("gitea.service")
      machine.wait_for_open_port(3000)
      machine.succeed("curl --fail http://localhost:3000/")
    '';
  };

  sqlite = makeTest {
    name = "gitea-sqlite";
    meta.maintainers = [ maintainers.aanderse ];

    machine =
      { config, pkgs, ... }:
      { services.gitea.enable = true;
        services.gitea.disableRegistration = true;
      };

    testScript = ''
      start_all()

      machine.wait_for_unit("gitea.service")
      machine.wait_for_open_port(3000)
      machine.succeed("curl --fail http://localhost:3000/")
      machine.succeed(
          "curl --fail http://localhost:3000/user/sign_up | grep 'Registration is disabled. Please contact your site administrator.'"
      )
    '';
  };
}
