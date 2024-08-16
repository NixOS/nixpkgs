import ../make-test-python.nix ({ pkgs, ... }: {
  name = "matrix-synapse-workers";
  meta = with pkgs.lib; {
    maintainers = teams.matrix.members;
  };

  nodes = {
    homeserver =
      { pkgs
      , nodes
      , ...
      }: {
        services.postgresql = {
          enable = true;
          initialScript = pkgs.writeText "synapse-init.sql" ''
            CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
            CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
            TEMPLATE template0
            LC_COLLATE = "C"
            LC_CTYPE = "C";
          '';
        };

        services.matrix-synapse = {
          enable = true;
          settings = {
            database = {
              name = "psycopg2";
              args.password = "synapse";
            };
            enable_registration = true;
            enable_registration_without_verification = true;

            federation_sender_instances = [ "federation_sender" ];
          };
          configureRedisLocally = true;
          workers = {
            "federation_sender" = { };
          };
        };
      };
  };

  testScript = ''
    start_all()

    homeserver.wait_for_unit("matrix-synapse.service");
    homeserver.wait_for_unit("matrix-synapse-worker-federation_sender.service");
  '';
})
