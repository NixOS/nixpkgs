{ config, pkgs, lib, ... }:

let
  inherit (lib) mkIf mkOption mkEnableOption mkPackageOption optional;
  cfg = config.services.swhkd;
in {
  options.services.swhkd = {
    enable = mkEnableOption (lib.mdDoc "simple wayland hotkey daemon");
    package = mkPackageOption pkgs "swhkd" {};
    installManpages = mkOption {
      type = lib.types.bool;
      default = true;
      description = "install swhkd manual pages";
    };
    swhkdrc = mkOption {
      type = lib.types.str;
      default = "";
      description = "contents of the system-wide swhkdrc file";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      [ cfg.package.bin cfg.package.out ] ++ optional cfg.installManpages cfg.package.man;
    environment.etc."swhkd/swhkdrc".text = cfg.swhkdrc;
    security.polkit.enable = true;
  };
}
