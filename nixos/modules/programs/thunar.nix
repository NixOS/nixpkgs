{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.thunar;
in
{
  meta = {
    maintainers = lib.teams.xfce.members;
  };

  options = {
    programs.thunar = {
      enable = lib.mkEnableOption "Thunar, the Xfce file manager";

      package = lib.mkPackageOption pkgs "xfce.thunar" {
        default = [ "xfce" "thunar" ];
      };


      finalPackage = lib.mkOption {
        type = lib.types.package;
        default = cfg.package.override { thunarPlugins = cfg.plugins; };
        visible = false;
        readOnly = true;
        description = "The resulting Thunar package, bundled with plugins";
      };

      plugins = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.package;
        description = "List of thunar plugins to install.";
        example = lib.literalExpression "with pkgs.xfce; [ thunar-archive-plugin thunar-volman ]";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.finalPackage
    ];

    services.dbus.packages = [
      cfg.finalPackage
    ];

    systemd.packages = [
      cfg.finalPackage
    ];

    programs.xfconf.enable = true;
  };
}
