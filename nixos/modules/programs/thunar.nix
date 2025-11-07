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

      plugins = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.package;
        description = "List of thunar plugins to install.";
        example = lib.literalExpression "with pkgs.xfce; [ thunar-archive-plugin thunar-volman ]";
      };

    };
  };

  config = lib.mkIf cfg.enable (
    let
      package = pkgs.xfce.thunar.override { thunarPlugins = cfg.plugins; };

    in
    {
      environment.systemPackages = [
        package
      ];

      services.dbus.packages = [
        package
      ];

      systemd.packages = [
        package
      ];

      programs.xfconf.enable = true;
    }
  );
}
