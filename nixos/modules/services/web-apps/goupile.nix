{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.goupile;
  goupileWebServiceName = "goupile";
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

      configFile = lib.mkOption {
        type = lib.types.path;
        description = ''
          The configuration file to be passed to goupile server.

          By default the configuration file is created from `services.goupile.settings`.
        '';
      };

      nginx = lib.mkOption {
        type = lib.types.submodule (
          lib.recursiveUpdate (import ../web-servers/nginx/vhost-options.nix { inherit config lib; }) { }
        );
        default = { };
        example = lib.literalExpression ''
          {
            serverAliases = [
              "goupile.''${config.networking.domain}"
            ];
            # To enable encryption and let let's encrypt take care of certificate
            forceSSL = true;
            enableACME = true;
          }
        '';
        description = "nginx virtualHost settings.";
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
        services.nginx = {
          enable = lib.mkDefault true;
          virtualHosts.${goupileWebServiceName} = lib.mkMerge [
            cfg.nginx
            {
              locations."/".proxyPass =
                "http://${goupileWebServiceName}:${builtins.toString cfg.settings.HTTP.Port}";
            }
          ];
        };
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

          serviceConfig = {
            ExecStart = ''
              ${lib.getExe cfg.package} \
                ${lib.optionalString cfg.enableSandbox "--sandbox"} \
                -C ${cfg.configFile}
            '';

            DynamicUser = true;

            RuntimeDirectory = "goupile";
            RuntimeDirectoryPreserve = "yes";
            StateDirectory = "goupile";
            UMask = 0077;
            WorkingDirectory = "%S/goupile";

            SystemCallArchitectures = "native";
            SystemCallFilter = [
              "~@privileged"
              "~@resources"
              "~@obsolete"
              "~@mount"
              "@system-service"
              "@file-system"
              "@basic-io"
              "@clock"
            ];

            ProtectHome = true;
            PrivateUsers = true;
            PrivateDevices = true;
            ProtectKernelLogs = true;
            ProtectControlGroups = true;
            ProtectKernelModules = true;

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

            Restart = "always";
            RestartSec = 20;
            TimeoutStopSec = 30;
            LimitNOFILE = 4096;
          };
        };
      }
    ]
  );

  meta.maintainers = lib.teams.ngi.members;
}
