# Module for MiniDLNA, a simple DLNA server.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.minidlna;
  settingsFormat = pkgs.formats.keyValue { listsAsDuplicateKeys = true; };
  settingsFile = settingsFormat.generate "minidlna.conf" cfg.settings;
in

{
  ###### interface
  options.services.minidlna.enable = mkOption {
    type = types.bool;
    default = false;
    description = ''
      Whether to enable MiniDLNA, a simple DLNA server.
      It serves media files such as video and music to DLNA client devices
      such as televisions and media players. If you use the firewall consider
      adding the following: <literal>services.minidlna.openFirewall = true;</literal>
    '';
  };

  options.services.minidlna.openFirewall = mkOption {
    type = types.bool;
    default = false;
    description = ''
      Whether to open both HTTP (TCP) and SSDP (UDP) ports in the firewall.
    '';
  };

  options.services.minidlna.settings = mkOption {
    default = {};
    description = ''
      The contents of MiniDLNA's configuration file.
      When the service is activated, a basic template is generated
      from the current options opened here.
    '';
    type = types.submodule {
      freeformType = settingsFormat.type;

      options.media_dir = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "/data/media" "V,/home/alice/video" ];
        description = ''
          Directories to be scanned for media files.
          The prefixes <literal>A,</literal>,<literal>V,</literal> and
          <literal>P,</literal> restrict a directory to audio, video
          or image files. The directories must be accessible to the
          <literal>minidlna</literal> user account.
        '';
      };
      options.notify_interval = mkOption {
        type = types.int;
        default = 90000;
        description = ''
          The interval between announces (in seconds).
          Instead of waiting on announces, one can open port UDP 1900 or
          set <literal>openFirewall</literal> option to use SSDP discovery.
          Furthermore announce interval has now been set as 90000 in order
          to prevent disconnects with certain clients and to rely solely
          on the SSDP method.

          Lower values (e.g. 60 seconds) should be used if one does not
          want to utilize SSDP. By default miniDLNA will announce its
          presence on the network approximately every 15 minutes. Many
          people prefer shorter announce intervals on their home networks,
          especially when DLNA clients are started on demand.

          Some relevant information can be found here:
          https://sourceforge.net/p/minidlna/discussion/879957/thread/1389d197/
        '';
      };
      options.port = mkOption {
        type = types.port;
        default = 8200;
        description = "Port number for HTTP traffic (descriptions, SOAP, media transfer).";
      };
      options.db_dir = mkOption {
        type = types.path;
        default = "/var/cache/minidlna";
        example = "/tmp/minidlna";
        description = "Specify the directory where you want MiniDLNA to store its database and album art cache.";
      };
      options.friendly_name = mkOption {
        type = types.str;
        default = "${config.networking.hostName} MiniDLNA";
        defaultText = literalExpression "config.networking.hostName";
        example = "rpi3";
        description = "Name that the DLNA server presents to clients.";
      };
      options.root_container = mkOption {
        type = types.str;
        default = ".";
        example = "B";
        description = "Use a different container as the root of the directory tree presented to clients.";
      };
      options.log_level = mkOption {
        type = types.str;
        default = "warn";
        example = "general,artwork,database,inotify,scanner,metadata,http,ssdp,tivo=warn";
        description = "Defines the type of messages that should be logged and down to which level of importance.";
      };
      options.inotify = mkOption {
        type = types.enum [ "yes" "no" ];
        default = "no";
        description = "Whether to enable inotify monitoring to automatically discover new files.";
      };
      options.enable_tivo = mkOption {
        type = types.enum [ "yes" "no" ];
        default = "no";
        description = "Support for streaming .jpg and .mp3 files to a TiVo supporting HMO.";
      };
      options.wide_links = mkOption {
        type = types.enum [ "yes" "no" ];
        default = "no";
        description = "Set this to yes to allow symlinks that point outside user-defined media_dirs.";
      };
    };
  };

  imports = [
    (mkRemovedOptionModule [ "services" "minidlna" "config" ] "")
    (mkRemovedOptionModule [ "services" "minidlna" "extraConfig" ] "")
    (mkRenamedOptionModule [ "services" "minidlna" "loglevel"] [ "services" "minidlna" "settings" "log_level" ])
    (mkRenamedOptionModule [ "services" "minidlna" "rootContainer"] [ "services" "minidlna" "settings" "root_container" ])
    (mkRenamedOptionModule [ "services" "minidlna" "mediaDirs"] [ "services" "minidlna" "settings" "media_dir" ])
    (mkRenamedOptionModule [ "services" "minidlna" "friendlyName"] [ "services" "minidlna" "settings" "friendly_name" ])
    (mkRenamedOptionModule [ "services" "minidlna" "announceInterval"] [ "services" "minidlna" "settings" "notify_interval" ])
  ];

  ###### implementation
  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.settings.port ];
    networking.firewall.allowedUDPPorts = mkIf cfg.openFirewall [ 1900 ];

    users.users.minidlna = {
      description = "MiniDLNA daemon user";
      group = "minidlna";
      uid = config.ids.uids.minidlna;
    };

    users.groups.minidlna.gid = config.ids.gids.minidlna;

    systemd.services.minidlna =
      { description = "MiniDLNA Server";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig =
          { User = "minidlna";
            Group = "minidlna";
            CacheDirectory = "minidlna";
            RuntimeDirectory = "minidlna";
            PIDFile = "/run/minidlna/pid";
            ExecStart =
              "${pkgs.minidlna}/sbin/minidlnad -S -P /run/minidlna/pid" +
              " -f ${settingsFile}";
          };
      };
  };
}
