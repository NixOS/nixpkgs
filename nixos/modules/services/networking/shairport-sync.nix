{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  cfg = config.services.shairport-sync;
  configFormat = pkgs.formats.libconfig { };
  configFile = configFormat.generate "shairport-sync.conf" cfg.settings;
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

      package = lib.options.mkPackageOption pkgs "shairport-sync" { };

      settings = mkOption {
        type = configFormat.type;
        default = {
          general.output_backend = "pa";
          diagnostics.log_verbosity = 1;
        };
        example = {
          general = {
            name = "NixOS Shairport";
            output_backend = "pw";
          };
          metadata = {
            enabled = "yes";
            include_cover_art = "yes";
            cover_art_cache_directory = "/tmp/shairport-sync/.cache/coverart";
            pipe_name = "/tmp/shairport-sync-metadata";
            pipe_timeout = 5000;
          };
          mqtt = {
            enabled = "yes";
            hostname = "mqtt.server.domain.example";
            port = 1883;
            publish_parsed = "yes";
            publish_cover = "yes";
          };
        };
        description = ''
          Configuration options for Shairport-Sync.

          See the example [shairport-sync.conf][example-file] for possible options.

          [example-file]: https://github.com/mikebrady/shairport-sync/blob/master/scripts/shairport-sync.conf
        '';
      };

      arguments = mkOption {
        type = types.str;
        default = "";
        description = ''
          Arguments to pass to the daemon. Defaults to a local pulseaudio
          server.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to automatically open ports in the firewall.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "shairport";
        description = ''
          User account name under which to run shairport-sync. The account
          will be created.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "shairport";
        description = ''
          Group account name under which to run shairport-sync. The account
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

    services.shairport-sync.settings = {
      general.output_backend = lib.mkDefault "pa";
      diagnostics.log_verbosity = lib.mkDefault 1;
    };

    users = {
      users.${cfg.user} = {
        description = "Shairport user";
        isSystemUser = true;
        createHome = true;
        home = "/var/lib/shairport-sync";
        group = cfg.group;
        extraGroups = [
          "audio"
        ]
        ++ optional (config.services.pulseaudio.enable || config.services.pipewire.pulse.enable) "pulse";
      };
      groups.${cfg.group} = { };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 5000 ];
      allowedUDPPortRanges = [
        {
          from = 6001;
          to = 6011;
        }
      ];
    };

    systemd.services.shairport-sync = {
      description = "shairport-sync";
      after = [
        "network.target"
        "avahi-daemon.service"
      ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${lib.getExe cfg.package} ${cfg.arguments}";
        Restart = "on-failure";
        RuntimeDirectory = "shairport-sync";
      };
    };

    environment = {
      systemPackages = [ cfg.package ];
      etc."shairport-sync.conf".source = configFile;
    };
  };

}
