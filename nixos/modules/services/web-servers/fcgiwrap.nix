{ config, lib, pkgs, ... }:

with lib;

let
  forEachInstance = f: flip mapAttrs' config.services.fcgiwrap (name: cfg:
    nameValuePair "fcgiwrap-${name}" (f cfg)
  );

in {
  options.services.fcgiwrap = mkOption {
    description = "Configuration for fcgiwrap instances.";
    default = { };
    type = types.attrsOf (types.submodule ({ config, ... }: { options = {
      process.prefork = mkOption {
        type = types.ints.positive;
        default = 1;
        description = "Number of processes to prefork.";
      };

      process.user = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          User as which this instance of fcgiwrap will be run.
          Set to `null` (the default) to use a dynamically allocated user.
        '';
      };

      process.group = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Group as which this instance of fcgiwrap will be run.";
      };

      socket.type = mkOption {
        type = types.enum [ "unix" "tcp" "tcp6" ];
        default = "unix";
        description = "Socket type: 'unix', 'tcp' or 'tcp6'.";
      };

      socket.address = mkOption {
        type = types.str;
        default = "/run/fcgiwrap-${config._module.args.name}.sock";
        example = "1.2.3.4:5678";
        description = ''
          Socket address.
          In case of a UNIX socket, this should be its filesystem path.
        '';
      };

      socket.user = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          User to be set as owner of the UNIX socket.
          Defaults to the process running user.
        '';
      };

      socket.group = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Group to be set as owner of the UNIX socket.
          Defaults to the process running group.
        '';
      };

      socket.mode = mkOption {
        type = types.nullOr types.str;
        default = if config.socket.type == "unix" then "0600" else null;
        defaultText = literalExpression ''
          if config.socket.type == "unix" then "0600" else null
        '';
        description = ''
          Mode to be set on the UNIX socket.
          Defaults to private to the socket's owner.
        '';
      };
    }; }));
  };

  config = {
    assertions = concatLists (mapAttrsToList (name: cfg: [
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
    ]) config.services.fcgiwrap);

    systemd.services = forEachInstance (cfg: {
      after = [ "nss-user-lookup.target" ];
      wantedBy = optional (cfg.socket.type != "unix") "multi-user.target";

      serviceConfig = {
        ExecStart = ''
          ${pkgs.fcgiwrap}/sbin/fcgiwrap ${cli.toGNUCommandLineShell {} ({
            c = cfg.process.prefork;
          } // (optionalAttrs (cfg.socket.type != "unix") {
            s = "${cfg.socket.type}:${cfg.socket.address}";
          }))}
        '';
      } // (if cfg.process.user != null then {
        User = cfg.process.user;
        Group = cfg.process.group;
      } else {
        DynamicUser = true;
      });
    });

    systemd.sockets = forEachInstance (cfg: mkIf (cfg.socket.type == "unix") {
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenStream = cfg.socket.address;
        SocketUser = cfg.socket.user;
        SocketGroup = cfg.socket.group;
        SocketMode = cfg.socket.mode;
      };
    });
  };
}
