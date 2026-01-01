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
<<<<<<< HEAD
        example = lib.literalExpression "with pkgs; [ thunar-archive-plugin thunar-volman ]";
=======
        example = lib.literalExpression "with pkgs.xfce; [ thunar-archive-plugin thunar-volman ]";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      };

    };
  };

  config = lib.mkIf cfg.enable (
    let
<<<<<<< HEAD
      package = pkgs.thunar.override { thunarPlugins = cfg.plugins; };
=======
      package = pkgs.xfce.thunar.override { thunarPlugins = cfg.plugins; };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
