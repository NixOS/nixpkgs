{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.calls;
in {
  options = {
    programs.calls = {
      enable = mkEnableOption ''
        Whether to enable GNOME calls: a phone dialer and call handler.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.calls
    ];

    services.dbus.packages = [
      pkgs.callaudiod
    ];
  };
}
