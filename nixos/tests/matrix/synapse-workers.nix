  import ../make-test-python.nix ({ pkgs, ... }:
  {
    name = "matrix-synapse-workers";
    meta = {
    maintainers = pkgs.matrix-synapse.meta.maintainers;
    };

    nodes = {
      homeserver = { pkgs, nodes, ... }: {
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

        services.redis.servers."".enable = true;

        services.matrix-synapse = {
          enable = true;
          settings = {
            enable_registration = true;
            enable_registration_without_verification = true;

            federation_sender_instances = [ "federation_sender" ];
          };
          workers.instances = {
            federation_sender = { };
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
