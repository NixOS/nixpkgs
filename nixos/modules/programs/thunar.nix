{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.thunar;

in {
  meta = {
    maintainers = teams.xfce.members;
  };

  options = {
    programs.thunar = {
      enable = mkEnableOption "Thunar, the Xfce file manager";

      plugins = mkOption {
        default = [];
        type = types.listOf types.package;
        description = lib.mdDoc "List of thunar plugins to install.";
        example = literalExpression "with pkgs.xfce; [ thunar-archive-plugin thunar-volman ]";
      };

    };
  };

  config = mkIf cfg.enable (
    let package = pkgs.xfce.thunar.override { thunarPlugins = cfg.plugins; };

    in {
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
