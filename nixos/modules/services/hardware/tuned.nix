{ config, pkgs, lib, ... }:
let
  cfg = config.services.tuned;
  p = pkgs.python39Packages.tuned;
in
{
  options.services.tuned = {
    enable = lib.mkEnableOption "tuned, a performance tuning daemon";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ p ];
    environment.etc.tuned = {
      source = "${p}/etc/tuned";
      mode = "0600";
    };
    systemd.packages = [ p ];
    systemd.tmpfiles.packages = [ p ];
    services.dbus.packages = [ p ];

  };
}
