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
      preforkProcesses = mkOption {
        type = types.int;
        default = 1;
        description = "Number of processes to prefork.";
      };

      socketType = mkOption {
        type = types.enum [ "unix" "tcp" "tcp6" ];
        default = "unix";
        description = "Socket type: 'unix', 'tcp' or 'tcp6'.";
      };

      socketAddress = mkOption {
        type = types.str;
        default = "/run/fcgiwrap-${config._module.args.name}.sock";
        example = "1.2.3.4:5678";
        description = "Socket address. In case of a UNIX socket, this should be its filesystem path.";
      };

      user = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "User permissions for the socket.";
      };

      group = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Group permissions for the socket.";
      };
    }; }));
  };

  config = {
    systemd.services = forEachInstance (cfg: {
      after = [ "nss-user-lookup.target" ];
      wantedBy = optional (cfg.socketType != "unix") "multi-user.target";

      serviceConfig = {
        ExecStart = "${pkgs.fcgiwrap}/sbin/fcgiwrap -c ${builtins.toString cfg.preforkProcesses} ${
          optionalString (cfg.socketType != "unix") "-s ${cfg.socketType}:${cfg.socketAddress}"
        }";
      } // (if cfg.user != null && cfg.group != null then {
        User = cfg.user;
        Group = cfg.group;
      } else { } );
    });

    systemd.sockets = forEachInstance (cfg: mkIf (cfg.socketType == "unix") {
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenStream = cfg.socketAddress;
      };
    });
  };
}
