{ config, lib, pkgs, ... }:

let

  cfg = config.services.shairport-sync;

in

{

  ###### interface

  options = {

    services.shairport-sync = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable the shairport-sync daemon.

          Running with a local system-wide or remote pulseaudio server
          is recommended.
        '';
      };

      package = lib.options.mkPackageOption pkgs "shairport-sync" { };

      arguments = lib.mkOption {
        type = lib.types.str;
        default = "-v -o pa";
        description = ''
          Arguments to pass to the daemon. Defaults to a local pulseaudio
          server.
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to automatically open ports in the firewall.
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "shairport";
        description = ''
          User account name under which to run shairport-sync. The account
          will be created.
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "shairport";
        description = ''
          Group account name under which to run shairport-sync. The account
          will be created.
        '';
      };

    };

  };


  ###### implementation

  config = lib.mkIf config.services.shairport-sync.enable {

    services.avahi.enable = true;
    services.avahi.publish.enable = true;
    services.avahi.publish.userServices = true;

    users = {
      users.${cfg.user} = {
        description = "Shairport user";
        isSystemUser = true;
        createHome = true;
        home = "/var/lib/shairport-sync";
        group = cfg.group;
        extraGroups = [ "audio" ] ++ lib.optional (config.services.pulseaudio.enable || config.services.pipewire.pulse.enable) "pulse";
      };
      groups.${cfg.group} = {};
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ 5000 ];
      allowedUDPPortRanges = [ { from = 6001; to = 6011; } ];
    };

    systemd.services.shairport-sync =
      {
        description = "shairport-sync";
        after = [ "network.target" "avahi-daemon.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = cfg.user;
          Group = cfg.group;
          ExecStart = "${lib.getExe cfg.package} ${cfg.arguments}";
          Restart = "on-failure";
          RuntimeDirectory = "shairport-sync";
        };
      };

    environment.systemPackages = [ cfg.package ];

  };

}
