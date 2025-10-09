{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.angrr;
in
{
  meta.maintainers = pkgs.angrr.meta.maintainers;
  options = {
    services.angrr = {
      enable = lib.mkEnableOption "angrr";
      package = lib.mkPackageOption pkgs "angrr" { };
      period = lib.mkOption {
        type = lib.types.str;
        default = "7d";
        example = "2weeks";
        description = ''
          The retention period of auto GC roots.
        '';
      };
      removeRoot = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to pass the `--remove-root` option to angrr.
        '';
      };
      ownedOnly = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Control the `--remove-root=<true|false>` option of angrr.
        '';
        apply = b: if b then "true" else "false";
      };
      logLevel = lib.mkOption {
        type =
          with lib.types;
          enum [
            "off"
            "error"
            "warn"
            "info"
            "debug"
            "trace"
          ];
        default = "info";
        description = ''
          Set the log level of angrr.
        '';
      };
      extraArgs = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ ];
        description = ''
          Extra command-line arguments pass to angrr.
        '';
      };
      enableNixGcIntegration = lib.mkOption {
        type = lib.types.bool;
        description = ''
          Whether to enable nix-gc.service integration
        '';
      };
      timer = {
        enable = lib.mkEnableOption "angrr timer";
        dates = lib.mkOption {
          type = lib.types.str;
          default = "03:00";
          description = ''
            How often or when the retention policy is performed.
          '';
        };
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        assertions = [
          {
            assertion = cfg.enableNixGcIntegration -> config.nix.gc.automatic;
            message = "angrr nix-gc.service integration requires `nix.gc.automatic = true`";
          }
        ];
        services.angrr.enableNixGcIntegration = lib.mkDefault config.nix.gc.automatic;
      }

      {
        systemd.services.angrr = {
          description = "Auto Nix GC Roots Retention";
          script = ''
            ${lib.getExe cfg.package} run \
              --log-level "${cfg.logLevel}" \
              --period "${cfg.period}" \
              ${lib.optionalString cfg.removeRoot "--remove-root"} \
              --owned-only="${cfg.ownedOnly}" \
              --no-prompt ${lib.escapeShellArgs cfg.extraArgs}
          '';
          serviceConfig = {
            Type = "oneshot";
          };
        };
      }

      (lib.mkIf cfg.timer.enable {
        systemd.timers.angrr = {
          timerConfig = {
            OnCalendar = cfg.timer.dates;
          };
          wantedBy = [ "timers.target" ];
        };
      })

      (lib.mkIf cfg.enableNixGcIntegration {
        systemd.services.angrr = {
          wantedBy = [ "nix-gc.service" ];
          before = [ "nix-gc.service" ];
        };
      })
    ]
  );
}
