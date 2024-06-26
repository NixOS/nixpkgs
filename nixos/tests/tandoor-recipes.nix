import ./make-test-python.nix (
  { lib, ... }:
  {
    name = "tandoor-recipes";
    meta.maintainers = with lib.maintainers; [ ambroisie ];

    nodes.machine =
      { pkgs, ... }:
      {
        services.tandoor-recipes = {
          enable = true;
          extraConfig = {
            DB_ENGINE = "django.db.backends.postgresql";
            POSTGRES_HOST = "/run/postgresql";
            POSTGRES_USER = "tandoor_recipes";
            POSTGRES_DB = "tandoor_recipes";
          };
        };

        services.postgresql = {
          enable = true;
          ensureDatabases = [ "tandoor_recipes" ];
          ensureUsers = [
            {
              name = "tandoor_recipes";
              ensureDBOwnership = true;
            }
          ];
        };

        systemd.services = {
          tandoor-recipes = {
            after = [ "postgresql.service" ];
          };
        };
      };

    testScript = ''
      machine.wait_for_unit("tandoor-recipes.service")

      with subtest("Web interface gets ready"):
          # Wait until server accepts connections
          machine.wait_until_succeeds("curl -fs localhost:8080")
    '';
  }
)
