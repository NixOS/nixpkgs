{ config, lib, pkgs, ... }:

let
  cfg = config.programs.calls;
in {
  options = {
    programs.calls = {
      enable = lib.mkEnableOption ''
        GNOME calls: a phone dialer and call handler
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.dconf.enable = true;

    environment.systemPackages = [
      pkgs.calls
    ];

    services.dbus.packages = [
      pkgs.callaudiod
    ];
  };
}
