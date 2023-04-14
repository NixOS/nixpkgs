{ commonConfigFile
, pluginsEnv
, format
}:

{ config, lib, pkgs, ... }: let
  format = pkgs.formats.yaml { };

  cfg = config.services.matrix-synapse;

  inherit (lib) mkOption types;

  # checks if given listener configuration has type as a resource
  isListenerType = type: l: lib.any (r: lib.any (n: n == type) r.names) l.resources;
  # Get the first listener that includes the given resource from worker
  firstListenerOfType = type: ls: lib.lists.findFirst (isListenerType type)
    (throw "No listener with resource: ${type} configured")
    ls;

  mainReplicationListener = firstListenerOfType "replication" cfg.settings.listeners;
in {
  options.services.matrix-synapse.workers = let
    workerInstanceType = types.submodule ({ config, ... }: {
      options.settings = mkOption {
        type = types.submodule {
          freeformType = format.type;

          options = {
            worker_app = mkOption {
              type = types.enum [
                "synapse.app.generic_worker"
                "synapse.app.media_repository"
              ];
              description = "The type of worker application";
              default = "synapse.app.generic_worker";
            };
            worker_listeners = mkOption {
              type = types.listOf workerListenerType;
              default = [ ];
              description = "Listener config for the worker, similar to the main synapse listener config";
            };
          };
        };
        default = { };
        description = "A freeform option of the workers settings, see upstream synapse documentation for options";
      };
    });

    workerListenerType = types.submodule {
      options = {
        type = mkOption {
          type = types.enum [ "http" "metrics" ];
          description = "The type of the listener";
          default = "http";
        };
        port = mkOption {
          type = types.port;
          description = "The TCP port to bind to";
        };
        bind_addresses = mkOption {
          type = with types; listOf str;
          description = "A list of local addresses to listen on";
          default = [ "127.0.0.1" "::1" ];
        };
        tls = mkOption {
          type = types.bool;
          description = ''
            Whether to enable TLS for this listener.
            Will use the TLS key/cert specified in tls_private_key_path / tls_certificate_path.
          '';
          default = false;
        };
        x_forwarded = mkOption {
          type = types.bool;
          description = ''
            Whether to use the X-Forwarded-For HTTP header as the client IP.
            This option is only valid for an 'http' listener.
            It is useful when Synapse is running behind a reverse-proxy.
          '';
          default = true;
        };
        resources = mkOption {
          type = types.listOf (types.submodule {
            options = {
              names = mkOption {
                type = types.listOf (types.enum [
                  "client"
                  "consent"
                  "federation"
                  "health"
                  "keys"
                  "media"
                  "metrics"
                  "openid"
                  "replication"
                  "static"
                ]);
                description = "A list of resources to host on this port";
                default = [ ];
                example = [ "client" ];
              };
              compress = lib.mkEnableOption "HTTP compression for this resource";
            };
          });
          default = [ { } ];
          description = "The resources to make available on this listener";
        };
      };
    };

  in {
    instances = mkOption {
      type = types.attrsOf workerInstanceType;
      default = { };
      example = {
        "federation_sender1" = {
          settings = { };
        };
        "federation_receiver1" = {
          settings = {
            worker_listeners = [
              { port = 8083;
                resources = [ { names = [ "federation" ];} ];
              }
            ];
          };
        };
      };
      description = "The name of the worker and its configuration";
    };
  };

  config = {
    services.matrix-synapse.settings.instance_map = lib.mkIf (cfg.workers.instances != { }) {
      main = let
        host = lib.head mainReplicationListener.bind_addresses;
      in {
        host = if builtins.elem host [ "0.0.0.0" "::"] then "127.0.0.1" else host;
        port = mainReplicationListener.port;
      };
    };

    systemd.services = let
      workerList = lib.mapAttrsToList lib.nameValuePair cfg.workers.instances;
      workerConfig = worker: format.generate "matrix-synapse-worker-${worker.name}-config.yaml"
        (worker.value.settings // { worker_name = worker.name; });
      in builtins.listToAttrs (lib.flip map workerList (worker: {
        name = "matrix-synapse-worker-${worker.name}";
        value = {
          description = "Matrix Synapse Worker";
          partOf = [ "matrix-synapse.target" ];
          wantedBy = [ "matrix-synapse.target" ];
          after = [ "matrix-synapse.service" ];
          requires = [ "matrix-synapse.service" ];
          environment = {
            PYTHONPATH = lib.makeSearchPathOutput "lib" cfg.package.python.sitePackages [
              pluginsEnv
            ];
          } // lib.optionalAttrs (cfg.withJemalloc) {
            LD_PRELOAD = "${pkgs.jemalloc}/lib/libjemalloc.so";
          };
          serviceConfig = {
            Type = "notify";
            User = "matrix-synapse";
            Group = "matrix-synapse";
            WorkingDirectory = cfg.dataDir;
            ExecStartPre = pkgs.writers.writeBash "wait-for-synapse" ''
              while ! systemctl is-active -q matrix-synapse.service; do
                  sleep 1
              done
            '';
            ExecStart = let
              flags = lib.cli.toGNUCommandLineShell {} {
                config-path = [ commonConfigFile (workerConfig worker) ] ++ cfg.extraConfigFiles;
                keys-directory = cfg.dataDir;
              };
            in "${cfg.package}/bin/synapse_worker ${flags}";
          };
        };
      }));
    };
  }
