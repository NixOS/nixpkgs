{ config, pkgs, lib, ... }:

let
  inherit (lib) mkIf mkOption mkEnableOption mkPackageOption optional;
  cfg = config.services.swhkd;
in {
  options.services.swhkd = {
    enable = mkEnableOption "simple wayland hotkey daemon";
    package = mkPackageOption pkgs "swhkd" {};
    swhkdrc = mkOption {
      type = lib.types.lines;
      default = "";
      description = "contents of the system-wide swhkdrc file. See {manpage}`swhkd(5) for more details on the config format.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ] ++ [ cfg.package.out ];
    environment.etc."swhkd/swhkdrc".text = cfg.swhkdrc;
    security.polkit.enable = true;
  };
}
