{ config, lib, pkgs, ... }:

let

  cfg = config.services.todesk;

in

{

  ###### interface
  options = {

    services.todesk.enable = lib.mkEnableOption "ToDesk daemon";

  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ pkgs.todesk ];

    systemd.services.todeskd = {
      description = "ToDesk Daemon Service";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" "nss-lookup.target" ];
      after = [ "network-online.target" ];
      before = [ "nss-lookup.target" ];
      requires = [ "dbus.service" ];
      serviceConfig = {
        Type = "simple";
        Environment = "LIBVA_DRIVER_NAME=iHD LIBVA_DRIVERS_PATH=${pkgs.todesk}/opt/todesk/bin";
        ExecStart = "${pkgs.todesk}/opt/todesk/bin/ToDeskService-Wrap";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGINT $MAINPID";
        Restart = "on-failure";
        User = "root";
      };
    };
  };

}
