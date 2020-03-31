# Run the mastodon package tests.  They can't be run as part of the
# package build because they require PostgreSQL and Redis.
import ../make-test-python.nix ({ pkgs, ...} :
{
  name = "mastodon-package-tests";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ happy-river ];
  };

  nodes = let
  in rec {
    machine =
      { ... }:
      {
        virtualisation.memorySize = 2048;
        virtualisation.diskSize = 1024;

        services.redis.enable = true;
        services.postgresql = {
          enable = true;
          ensureUsers = [
            {
              name = "tester";
              ensurePermissions = {
                "DATABASE mastodon_test" = "ALL PRIVILEGES";
              };
            }
          ];
          ensureDatabases = [
            "mastodon_test"
          ];
        };

        users.extraUsers.tester = {
          isNormalUser = true;
          home = "/home/tester";
        };
        environment.variables = {
          RAILS_ENV = "test";
          DISABLE_SIMPLECOV = "true";
          # Variables below must match the contents of mastodon's .env.test.
          NODE_ENV = "test";
          LOCAL_DOMAIN = "cb6e6126.ngrok.io";
          LOCAL_HTTPS = "true";
        };
        environment.systemPackages = with pkgs; [
          mastodon nodejs-slim yarn ffmpeg imagemagick file
        ];
      };
    };

  testScript = ''
    def su(cmd):
        return f"su - tester -c '{cmd}'"


    start_all()
    machine.succeed(
        su(
            "cp -r ${pkgs.mastodon} mastodon;"
            "chmod -R u+w mastodon;"
            "rm mastodon/{log,tmp}; mkdir mastodon/{log,tmp};"
            "rm -r mastodon/node_modules mastodon/public/{assets,packs};"
            "cp -rH ${pkgs.mastodon}/node_modules mastodon/node_modules;"
            "chmod -R u+w mastodon/node_modules"
        )
    )

    machine.succeed(su("cd mastodon; env NODE_ENV=tests rails webpacker:compile"))
    machine.succeed(su("cd mastodon; rails db:environment:set"))
    machine.succeed(su("cd mastodon; rails db:schema:load"))
    machine.log(
        machine.succeed(su("cd mastodon; rspec --seed 12345 --no-color"))
    )  # Ruby tests.
    machine.log(machine.succeed(su("cd mastodon; yarn run jest")))  # Javascript tests.
  '';
})
