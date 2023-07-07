{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.calls;
in {
  options = {
    programs.calls = {
      enable = mkEnableOption (lib.mdDoc ''
        Whether to enable GNOME calls: a phone dialer and call handler.
      '');
    };
  };

  config = mkIf cfg.enable {
    programs.dconf.enable = true;

    environment.systemPackages = [
      pkgs.calls
    ];

    services.dbus.packages = [
      pkgs.callaudiod
    ];
  };
}
