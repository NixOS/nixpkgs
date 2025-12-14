{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.goupile;

  settingsFormat = pkgs.formats.ini { };
in
{
  options = {
    services.goupile = {
      enable = lib.mkEnableOption "Goupile server";
      package = lib.mkPackageOption pkgs "goupile" { };

      enableSandbox = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable the sandbox option.";
      };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = settingsFormat.type;
          options = {
            HTTP.Port = lib.mkOption {
              type = lib.types.port;
              default = 8889;
              description = "The port goupile runs on";
            };
            Data.RootDirectory = lib.mkOption {
              type = lib.types.str;
              default = "/var/lib/goupile";
              description = "Goupile's data directory";
            };
          };
        };
        default = { }; # default will be lost for submodules if overriden
        example = lib.literalExpression ''
          {
            HTTP.Port = 8888;
          }
        '';
        description = ''
          The options for `systemd.services.goupile` in ini format.

          The configuration options available can be found here
          https://github.com/Koromix/rygel/blob/goupile/3.11.1/src/goupile/server/admin.cc#L41
        '';
      };

      # TODO decide, do we need settings+configFile+extraConfig?
      configFile = lib.mkOption {
        type = lib.types.path;
        description = ''
          The configuration file to be passed to goupile server.

          By default the configuration file is created from `services.goupile.settings`.
        '';
      };
    };
  };
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services.goupile.configFile = lib.mkOptionDefault (
          settingsFormat.generate "goupile.ini" cfg.settings
        );
      }
      {
        systemd.services.goupile = {
          wants = [ "network-online.target" ];
          after = [ "network-online.target" ];
          wantedBy = [ "multi-user.target" ];

          unitConfig = {
            Documentation = "https://goupile.org/en";
            Description = "Goupile eCRF";
          };

          # path = [ pkgs.coreutils ]; # doesn't work?

          serviceConfig = {
            ExecStartPre = [
              #"${pkgs.coreutils}/bin/echo $PATH"
              "${pkgs.coreutils}/bin/mkdir -p /var/lib/goupile/instances" # just mkdir doesn't work
            ];
            # ${pkgs.strace}/bin/strace
            ExecStart = ''
              ${lib.getExe cfg.package} \
                ${lib.optionalString cfg.enableSandbox "--sandbox"} \
                -C ${cfg.configFile}
            '';

            #Type = "notify"; #??
            DynamicUser = true;
            #User = "root";

            RuntimeDirectory = "goupile";
            RuntimeDirectoryPreserve = "yes";
            StateDirectory = "goupile";
            UMask = 0077;
            WorkingDirectory = "%S/goupile";

            SystemCallArchitectures = "native";
            SystemCallFilter = [
              "@system-service ~@privileged @clock"
              #"@default"
              #"@known"
            ];

            # dovecot
            /*
              CapabilityBoundingSet = [
               "CAP_SYS_PTRACE"
               "CAP_CHOWN"
               "CAP_DAC_OVERRIDE"
               "CAP_FOWNER"
               "CAP_KILL" # Required for child process management
               "CAP_NET_BIND_SERVICE"
               "CAP_SETGID"
               "CAP_SETUID"
               "CAP_SYS_CHROOT"
               "CAP_SYS_RESOURCE"
              ];
            */

            Restart = "always";
            RestartSec = 20;
            TimeoutStopSec = 30;
            LimitNOFILE = 4096;
            # TODO systemd-analyze security goupile
          };
        };
      }
    ]
  );
}
