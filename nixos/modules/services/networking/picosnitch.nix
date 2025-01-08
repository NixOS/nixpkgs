{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.picosnitch;
in
{
  options.services.picosnitch = {
    enable = lib.mkEnableOption "picosnitch daemon";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.picosnitch ];
    systemd.services.picosnitch = {
      description = "picosnitch";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 5;
        ExecStart = "${pkgs.picosnitch}/bin/picosnitch start-no-daemon";
        PIDFile = "/run/picosnitch/picosnitch.pid";
      };
    };
  };
}
