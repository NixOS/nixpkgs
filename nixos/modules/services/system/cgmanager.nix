{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.cgmanager;
in {
  meta.maintainers = [ maintainers.mic92 ];

  ###### interface
  options.services.cgmanager.enable = mkEnableOption "cgmanager";

  ###### implementation
  config = mkIf cfg.enable {
    systemd.services.cgmanager = {
      wantedBy = [ "multi-user.target" ];
      description = "Cgroup management daemon";
      restartIfChanged = false;
      serviceConfig = {
        ExecStart = "${pkgs.cgmanager}/bin/cgmanager -m name=systemd";
        KillMode = "process";
        Restart = "on-failure";
      };
    };
  };
}
