# Module for MiniDLNA, a simple DLNA server.
{ config, lib, pkgs, ... }:

let
  cfg = config.services.minidlna;
  settingsFormat = pkgs.formats.keyValue { listsAsDuplicateKeys = true; };
  settingsFile = settingsFormat.generate "minidlna.conf" cfg.settings;
in

{
  ###### interface
  options.services.minidlna.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = ''
      Whether to enable MiniDLNA, a simple DLNA server.
      It serves media files such as video and music to DLNA client devices
      such as televisions and media players. If you use the firewall, consider
      adding the following: `services.minidlna.openFirewall = true;`
    '';
  };

  options.services.minidlna.package = lib.mkPackageOption pkgs "minidlna" { };

  options.services.minidlna.openFirewall = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = ''
      Whether to open both HTTP (TCP) and SSDP (UDP) ports in the firewall.
    '';
  };

  options.services.minidlna.settings = lib.mkOption {
    default = {};
    description = ''
      The contents of MiniDLNA's configuration file.
      When the service is activated, a basic template is generated from the current options opened here.
    '';
    type = lib.types.submodule {
      freeformType = settingsFormat.type;

      options.media_dir = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        example = [ "/data/media" "V,/home/alice/video" ];
        description = ''
          Directories to be scanned for media files.
          The `A,` `V,` `P,` prefixes restrict a directory to audio, video or image files.
          The directories must be accessible to the `minidlna` user account.
        '';
      };
      options.notify_interval = lib.mkOption {
        type = lib.types.int;
        default = 90000;
        description = ''
          The interval between announces (in seconds).
          Instead of waiting for announces, you should set `openFirewall` option to use SSDP discovery.
          Lower values (e.g. 30 seconds) should be used if your network blocks the discovery unicast.
          Some relevant information can be found here:
          https://sourceforge.net/p/minidlna/discussion/879957/thread/1389d197/
        '';
      };
      options.port = lib.mkOption {
        type = lib.types.port;
        default = 8200;
        description = "Port number for HTTP traffic (descriptions, SOAP, media transfer).";
      };
      options.db_dir = lib.mkOption {
        type = lib.types.path;
        default = "/var/cache/minidlna";
        example = "/tmp/minidlna";
        description = "Specify the directory where you want MiniDLNA to store its database and album art cache.";
      };
      options.friendly_name = lib.mkOption {
        type = lib.types.str;
        default = config.networking.hostName;
        defaultText = lib.literalExpression "config.networking.hostName";
        example = "rpi3";
        description = "Name that the DLNA server presents to clients.";
      };
      options.root_container = lib.mkOption {
        type = lib.types.str;
        default = "B";
        example = ".";
        description = "Use a different container as the root of the directory tree presented to clients.";
      };
      options.log_level = lib.mkOption {
        type = lib.types.str;
        default = "warn";
        example = "general,artwork,database,inotify,scanner,metadata,http,ssdp,tivo=warn";
        description = "Defines the type of messages that should be logged and down to which level of importance.";
      };
      options.inotify = lib.mkOption {
        type = lib.types.enum [ "yes" "no" ];
        default = "no";
        description = "Whether to enable inotify monitoring to automatically discover new files.";
      };
      options.enable_tivo = lib.mkOption {
        type = lib.types.enum [ "yes" "no" ];
        default = "no";
        description = "Support for streaming .jpg and .mp3 files to a TiVo supporting HMO.";
      };
      options.wide_links = lib.mkOption {
        type = lib.types.enum [ "yes" "no" ];
        default = "no";
        description = "Set this to yes to allow symlinks that point outside user-defined `media_dir`.";
      };
    };
  };

  imports = [
    (lib.mkRemovedOptionModule [ "services" "minidlna" "config" ] "")
    (lib.mkRemovedOptionModule [ "services" "minidlna" "extraConfig" ] "")
    (lib.mkRenamedOptionModule [ "services" "minidlna" "loglevel"] [ "services" "minidlna" "settings" "log_level" ])
    (lib.mkRenamedOptionModule [ "services" "minidlna" "rootContainer"] [ "services" "minidlna" "settings" "root_container" ])
    (lib.mkRenamedOptionModule [ "services" "minidlna" "mediaDirs"] [ "services" "minidlna" "settings" "media_dir" ])
    (lib.mkRenamedOptionModule [ "services" "minidlna" "friendlyName"] [ "services" "minidlna" "settings" "friendly_name" ])
    (lib.mkRenamedOptionModule [ "services" "minidlna" "announceInterval"] [ "services" "minidlna" "settings" "notify_interval" ])
  ];

  ###### implementation
  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.settings.port ];
    networking.firewall.allowedUDPPorts = lib.mkIf cfg.openFirewall [ 1900 ];

    users.users.minidlna = {
      description = "MiniDLNA daemon user";
      group = "minidlna";
      uid = config.ids.uids.minidlna;
    };

    users.groups.minidlna.gid = config.ids.gids.minidlna;

    systemd.services.minidlna = {
      description = "MiniDLNA Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        User = "minidlna";
        Group = "minidlna";
        CacheDirectory = "minidlna";
        RuntimeDirectory = "minidlna";
        PIDFile = "/run/minidlna/pid";
        ExecStart = "${lib.getExe cfg.package} -S -P /run/minidlna/pid -f ${settingsFile}";
      };
    };
  };
}
