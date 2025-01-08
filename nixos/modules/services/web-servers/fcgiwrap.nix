{
  config,
  lib,
  pkgs,
  ...
}:

let
  forEachInstance =
    f:
    lib.flip lib.mapAttrs' config.services.fcgiwrap.instances (
      name: cfg: lib.nameValuePair "fcgiwrap-${name}" (f cfg)
    );

in
{
  imports =
    lib.forEach
      [
        "enable"
        "user"
        "group"
        "socketType"
        "socketAddress"
        "preforkProcesses"
      ]
      (
        attr:
        lib.mkRemovedOptionModule [ "services" "fcgiwrap" attr ] ''
          The global shared fcgiwrap instance is no longer supported due to
          security issues.
          Isolated instances should instead be configured through
          `services.fcgiwrap.instances.*'.
        ''
      );

  options.services.fcgiwrap.instances = lib.mkOption {
    description = "Configuration for fcgiwrap instances.";
    default = { };
    type = lib.types.attrsOf (
      lib.types.submodule (
        { config, ... }:
        {
          options = {
            process.prefork = lib.mkOption {
              type = lib.types.ints.positive;
              default = 1;
              description = "Number of processes to prefork.";
            };

            process.user = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = ''
                User as which this instance of fcgiwrap will be run.
                Set to `null` (the default) to use a dynamically allocated user.
              '';
            };

            process.group = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Group as which this instance of fcgiwrap will be run.";
            };

            socket.type = lib.mkOption {
              type = lib.types.enum [
                "unix"
                "tcp"
                "tcp6"
              ];
              default = "unix";
              description = "Socket type: 'unix', 'tcp' or 'tcp6'.";
            };

            socket.address = lib.mkOption {
              type = lib.types.str;
              default = "/run/fcgiwrap-${config._module.args.name}.sock";
              example = "1.2.3.4:5678";
              description = ''
                Socket address.
                In case of a UNIX socket, this should be its filesystem path.
              '';
            };

            socket.user = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = ''
                User to be set as owner of the UNIX socket.
              '';
            };

            socket.group = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = ''
                Group to be set as owner of the UNIX socket.
              '';
            };

            socket.mode = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = if config.socket.type == "unix" then "0600" else null;
              defaultText = lib.literalExpression ''
                if config.socket.type == "unix" then "0600" else null
              '';
              description = ''
                Mode to be set on the UNIX socket.
                Defaults to private to the socket's owner.
              '';
            };
          };
        }
      )
    );
  };

  config = {
    assertions = lib.concatLists (
      lib.mapAttrsToList (name: cfg: [
        {
          assertion = cfg.socket.type == "unix" -> cfg.socket.user != null;
          message = "Socket owner is required for the UNIX socket type.";
        }
        {
          assertion = cfg.socket.type == "unix" -> cfg.socket.group != null;
          message = "Socket owner is required for the UNIX socket type.";
        }
        {
          assertion = cfg.socket.user != null -> cfg.socket.type == "unix";
          message = "Socket owner can only be set for the UNIX socket type.";
        }
        {
          assertion = cfg.socket.group != null -> cfg.socket.type == "unix";
          message = "Socket owner can only be set for the UNIX socket type.";
        }
        {
          assertion = cfg.socket.mode != null -> cfg.socket.type == "unix";
          message = "Socket mode can only be set for the UNIX socket type.";
        }
      ]) config.services.fcgiwrap.instances
    );

    systemd.services = forEachInstance (cfg: {
      after = [ "nss-user-lookup.target" ];
      wantedBy = lib.optional (cfg.socket.type != "unix") "multi-user.target";

      serviceConfig =
        {
          ExecStart = ''
            ${pkgs.fcgiwrap}/sbin/fcgiwrap ${
              lib.cli.toGNUCommandLineShell { } (
                {
                  c = cfg.process.prefork;
                }
                // (lib.optionalAttrs (cfg.socket.type != "unix") {
                  s = "${cfg.socket.type}:${cfg.socket.address}";
                })
              )
            }
          '';
        }
        // (
          if cfg.process.user != null then
            {
              User = cfg.process.user;
              Group = cfg.process.group;
            }
          else
            {
              DynamicUser = true;
            }
        );
    });

    systemd.sockets = forEachInstance (
      cfg:
      lib.mkIf (cfg.socket.type == "unix") {
        wantedBy = [ "sockets.target" ];
        socketConfig = {
          ListenStream = cfg.socket.address;
          SocketUser = cfg.socket.user;
          SocketGroup = cfg.socket.group;
          SocketMode = cfg.socket.mode;
        };
      }
    );
  };
}
