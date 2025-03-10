{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    getExe
    maintainers
    mapAttrs
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkOptionDefault
    types
    ;

  cfg = config.services.lact;
  settingsFormat = pkgs.formats.yaml { };

  configFile =
    if cfg.configFile == null then
      settingsFormat.generate "config.yaml" cfg.settings
    else
      cfg.configFile;
in
{
  options.services.lact = {
    enable = mkEnableOption "LACT, for controlling AMD GPUs";
    gpuOverclock = {
      enable = mkEnableOption "GPU overclocking";
      ppfeaturemask = mkOption {
        type = types.str;
        default = "0xfffd7fff";
        example = "0xffffffff";
        description = ''
          Sets the `amdgpu.ppfeaturemask` kernel option. In particular, it is used here to set the
          overdrive bit. Default is `0xfffd7fff` as it is less likely to cause flicker issues. Setting
          it to `0xffffffff` enables all features.
        '';
      };
    };
    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to a LACT `config.yaml`. Mutually exclusive with the `settings` option.

        It is recommended to run the LACT GUI, generate your configuration there,
        and then use it here.
      '';
    };
    settings = mkOption {
      type = settingsFormat.type;
      default = mapAttrs (n: mkOptionDefault) {
        daemon = {
          log_level = "info";
          admin_groups = [
            "wheel"
            "sudo"
          ];
          disable_clocks_cleanup = false;
        };
        apply_settings_timer = 5;
        gpus = { };
      };
      description = ''
        LACT configuration as an attribute set.

        It is recommended to run the LACT GUI, generate your configuration there,
        and then copy it into `settings`.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      assertions = [
        {
          assertion = (cfg.settings != { }) != (cfg.configFile != null);
          message = "The `settings` and `configFile` options are mutually exclusive.";
        }
      ];

      environment.etc."lact/config.yaml".source = configFile;

      # Copied from https://github.com/ilya-zlobintsev/LACT/blob/master/res/lactd.service
      systemd.services.lactd = {
        wantedBy = [ "multi-user.target" ];
        unitConfig = {
          Description = "AMDGPU Control Daemon";
          After = [ "multi-user.target" ];
        };
        serviceConfig = {
          ExecStart = "${getExe pkgs.lact} daemon";
          Nice = -10;
        };
      };

      environment.systemPackages = [ pkgs.lact ];
    }
    (mkIf cfg.gpuOverclock.enable {
      # https://wiki.archlinux.org/title/AMDGPU#Boot_parameter
      boot.kernelParams = [ "amdgpu.ppfeaturemask=${cfg.gpuOverclock.ppfeaturemask}" ];
    })
  ]);

  meta.maintainers = [ maintainers.PopeRigby ];
}
