{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing.nix { inherit system pkgs; };
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
      startAll;

      $machine->waitForUnit('gitea.service');
      $machine->waitForOpenPort('3000');
      $machine->succeed("curl --fail http://localhost:3000/");
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
      startAll;

      $machine->waitForUnit('gitea.service');
      $machine->waitForOpenPort('3000');
      $machine->succeed("curl --fail http://localhost:3000/");
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
      startAll;

      $machine->waitForUnit('gitea.service');
      $machine->waitForOpenPort('3000');
      $machine->succeed("curl --fail http://localhost:3000/");
      $machine->succeed("curl --fail http://localhost:3000/user/sign_up | grep 'Registration is disabled. Please contact your site administrator.'");
    '';
  };
}
