{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.fcgiwrap;
  deprecationNote = ''

    This global instance option is deprecated in favour of per-instance
    options configured through `services.fcgiwrap.instances.*`.
  '';
  securityWarning = ''
    The fcgiwrap module is configured with a global shared instance.
    This has security implications. See advisory: https://discourse.nixos.org/t/51419
    Isolated instances should instead be configured through `services.fcgiwrap.instances.*'.
    The global options at `services.fcgiwrap.*` will be removed in NixOS 24.11.
  '';

in
{

  options = {
    services.fcgiwrap = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description =
          "Whether to enable fcgiwrap, a server for running CGI applications over FastCGI." + deprecationNote;
      };

      allowGlobalInstanceLocalPrivilegeEscalation = mkOption {
        type = types.bool;
        default = false;
        description = ''
          The global instance of fcgiwrap configured through this module
          has a local privilege escalation vulnerability.
          Set this option to true to accept the risk and bypass the evaluation
          failure regardless.
        '';
      };

      preforkProcesses = mkOption {
        type = types.int;
        default = 1;
        description = "Number of processes to prefork." + deprecationNote;
      };

      socketType = mkOption {
        type = types.enum [
          "unix"
          "tcp"
          "tcp6"
        ];
        default = "unix";
        description = "Socket type: 'unix', 'tcp' or 'tcp6'." + deprecationNote;
      };

      socketAddress = mkOption {
        type = types.str;
        default = "/run/fcgiwrap.sock";
        example = "1.2.3.4:5678";
        description =
          "Socket address. In case of a UNIX socket, this should be its filesystem path." + deprecationNote;
      };

      user = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "User permissions for the socket." + deprecationNote;
      };

      group = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Group permissions for the socket." + deprecationNote;
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.allowGlobalInstanceLocalPrivilegeEscalation;
        message =
          securityWarning
          + ''
            To temporarily accept the risk and continue using the global instance,
            set `services.fcgiwrap.allowGlobalInstanceLocalPrivilegeEscalation` to true.
          '';
      }
    ];

    warnings = [ securityWarning ];

    systemd.services.fcgiwrap = {
      after = [ "nss-user-lookup.target" ];
      wantedBy = optional (cfg.socketType != "unix") "multi-user.target";

      serviceConfig =
        {
          ExecStart = "${pkgs.fcgiwrap}/sbin/fcgiwrap -c ${builtins.toString cfg.preforkProcesses} ${
            optionalString (cfg.socketType != "unix") "-s ${cfg.socketType}:${cfg.socketAddress}"
          }";
        }
        // (
          if cfg.user != null && cfg.group != null then
            {
              User = cfg.user;
              Group = cfg.group;
            }
          else
            { }
        );
    };

    systemd.sockets =
      if (cfg.socketType == "unix") then
        {
          fcgiwrap = {
            wantedBy = [ "sockets.target" ];
            socketConfig.ListenStream = cfg.socketAddress;
          };
        }
      else
        { };
  };
}
