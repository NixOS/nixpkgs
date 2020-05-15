{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.shairport-sync;

in

{

  ###### interface

  options = {

    services.shairport-sync = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable the shairport-sync daemon.

          Running with a local system-wide or remote pulseaudio server
          is recommended.
        '';
      };

      arguments = mkOption {
        default = "-v -o pa";
        description = ''
          Arguments to pass to the daemon. Defaults to a local pulseaudio
          server.
        '';
      };

      user = mkOption {
        default = "shairport";
        description = ''
          User account name under which to run shairport-sync. The account
          will be created.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.shairport-sync.enable {

    services.avahi.enable = true;
    services.avahi.publish.enable = true;
    services.avahi.publish.userServices = true;

    users.users.${cfg.user} =
      { description = "Shairport user";
        isSystemUser = true;
        createHome = true;
        home = "/var/lib/shairport-sync";
        extraGroups = [ "audio" ] ++ optional config.hardware.pulseaudio.enable "pulse";
      };

    systemd.services.shairport-sync =
      {
        description = "shairport-sync";
        after = [ "network.target" "avahi-daemon.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = cfg.user;
          ExecStart = "${pkgs.shairport-sync}/bin/shairport-sync ${cfg.arguments}";
          RuntimeDirectory = "shairport-sync";
        };
      };

    environment.systemPackages = [ pkgs.shairport-sync ];

  };

}
