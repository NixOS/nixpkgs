{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.cliphist;
in
{
  meta.maintainers = with lib.maintainers; [ xavwe ];

  options.services.cliphist = {
    enable = lib.mkEnableOption "Wayland clipboard manager with support for multimedia";

    package = lib.mkPackageOption pkgs "cliphist" { };

    clipboardPackage = lib.mkPackageOption pkgs "wl-clipboard" { };

    supportImages = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Add support for images
      '';
    };

    extraFlags = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = ''
        Extra flags to pass to wl-clip-persist
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
      cfg.clipboardPackage
    ];

    systemd.user.services = {
      cliphist = {
        enable = true;
        description = "cliphist daemon";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig.ExecStart = "${lib.getExe' cfg.clipboardPackage "wl-paste"} --watch ${lib.getExe cfg.package} ${lib.escapeShellArgs cfg.extraFlags} store";
      };

      cliphist-images = lib.mkIf cfg.supportImages {
        enable = true;
        description = "cliphist daemon - images";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig.ExecStart = "${lib.getExe' cfg.clipboardPackage "wl-paste"} --type image --watch ${lib.getExe cfg.package} ${lib.escapeShellArgs cfg.extraFlags} store";
      };
    };
  };
}
