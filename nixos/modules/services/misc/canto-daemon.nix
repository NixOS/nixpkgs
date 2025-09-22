{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.canto-daemon;

in
{

  ##### interface

  options = {

    services.canto-daemon = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable the canto RSS daemon.";
      };
    };

  };

  ##### implementation

  config = lib.mkIf cfg.enable {

    systemd.user.services.canto-daemon = {
      description = "Canto RSS Daemon";
      after = [ "network.target" ];
      wantedBy = [ "default.target" ];
      serviceConfig.ExecStart = "${pkgs.canto-daemon}/bin/canto-daemon";
    };
  };

}
