{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.dolphin;
in
{
  meta = {
    maintainers = lib.teams.kde.members;
  };

  options = {
    programs.dolphin = {
      enable = lib.mkEnableOption "Dolphin, the Plasma file manager";

      package = lib.mkPackageOption pkgs "kdePackages.dolphin" {
        default = [
          "kdePackages"
          "dolphin"
        ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      etc."xdg/menus/applications.menu".source =
        "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

      systemPackages = with pkgs; [
        cfg.package
        baloo-widgets # baloo information in Dolphin
        dolphin-plugins
      ];
    };
  };
}
