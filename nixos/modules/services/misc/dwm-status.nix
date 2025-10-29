{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.dwm-status;

  format = pkgs.formats.toml { };

  configFile = format.generate "dwm-status.toml" cfg.settings;
in

{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "dwm-status" "order" ]
      [ "services" "dwm-status" "settings" "order" ]
    )
    (lib.mkRemovedOptionModule [
      "services"
      "dwm-status"
      "extraConfig"
    ] "Use services.dwm-status.settings instead.")
  ];

  options = {
    services.dwm-status = {
      enable = lib.mkEnableOption "dwm-status user service";

      package = lib.mkPackageOption pkgs "dwm-status" {
        example = "dwm-status.override { enableAlsaUtils = false; }";
      };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = format.type;
          options.order = lib.mkOption {
            type = lib.types.listOf (
              lib.types.enum [
                "audio"
                "backlight"
                "battery"
                "cpu_load"
                "network"
                "time"
              ]
            );
            default = [ ];
            description = ''
              List of enabled features in order.
            '';
          };
        };
        default = { };
        example = {
          order = [
            "battery"
            "cpu_load"
            "time"
          ];
          time = {
            format = "%F %a %r";
            update_seconds = true;
          };
        };
        description = ''
          Config options for dwm-status, see <https://github.com/Gerschtli/dwm-status#configuration>
          for available options.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.upower.enable = lib.mkIf (lib.elem "battery" cfg.settings.order) true;

    systemd.user.services.dwm-status = {
      description = "Highly performant and configurable DWM status service";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig.ExecStart = "${cfg.package}/bin/dwm-status ${configFile} --quiet";
    };
  };
}
