{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.resilio;

  resilioSync = pkgs.resilio-sync;

  sharedFoldersRecord = map (entry: {
    secret = entry.secret;
    dir = entry.directory;

    use_relay_server = entry.useRelayServer;
    use_tracker = entry.useTracker;
    use_dht = entry.useDHT;

    search_lan = entry.searchLAN;
    use_sync_trash = entry.useSyncTrash;
    known_hosts = entry.knownHosts;
  }) cfg.sharedFolders;

  configFile = pkgs.writeText "config.json" (builtins.toJSON ({
    device_name = cfg.deviceName;
    storage_path = cfg.storagePath;
    listening_port = cfg.listeningPort;
    use_gui = false;
    check_for_updates = cfg.checkForUpdates;
    use_upnp = cfg.useUpnp;
    download_limit = cfg.downloadLimit;
    upload_limit = cfg.uploadLimit;
    lan_encrypt_data = cfg.encryptLAN;
  } // optionalAttrs (cfg.directoryRoot != "") { directory_root = cfg.directoryRoot; }
    // optionalAttrs cfg.enableWebUI {
    webui = { listen = "${cfg.httpListenAddr}:${toString cfg.httpListenPort}"; } //
      (optionalAttrs (cfg.httpLogin != "") { login = cfg.httpLogin; }) //
      (optionalAttrs (cfg.httpPass != "") { password = cfg.httpPass; }) //
      (optionalAttrs (cfg.apiKey != "") { api_key = cfg.apiKey; });
  } // optionalAttrs (sharedFoldersRecord != []) {
    shared_folders = sharedFoldersRecord;
  }));

in
{
  options = {
    services.resilio = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          If enabled, start the Resilio Sync daemon. Once enabled, you can
          interact with the service through the Web UI, or configure it in your
          NixOS configuration.
        '';
      };

      deviceName = mkOption {
        type = types.str;
        example = "Voltron";
        default = config.networking.hostName;
        defaultText = literalExpression "config.networking.hostName";
        description = lib.mdDoc ''
          Name of the Resilio Sync device.
        '';
      };

      listeningPort = mkOption {
        type = types.int;
        default = 0;
        example = 44444;
        description = lib.mdDoc ''
          Listening port. Defaults to 0 which randomizes the port.
        '';
      };

      checkForUpdates = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Determines whether to check for updates and alert the user
          about them in the UI.
        '';
      };

      useUpnp = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Use Universal Plug-n-Play (UPnP)
        '';
      };

      downloadLimit = mkOption {
        type = types.int;
        default = 0;
        example = 1024;
        description = lib.mdDoc ''
          Download speed limit. 0 is unlimited (default).
        '';
      };

      uploadLimit = mkOption {
        type = types.int;
        default = 0;
        example = 1024;
        description = lib.mdDoc ''
          Upload speed limit. 0 is unlimited (default).
        '';
      };

      httpListenAddr = mkOption {
        type = types.str;
        default = "[::1]";
        example = "0.0.0.0";
        description = lib.mdDoc ''
          HTTP address to bind to.
        '';
      };

      httpListenPort = mkOption {
        type = types.int;
        default = 9000;
        description = lib.mdDoc ''
          HTTP port to bind on.
        '';
      };

      httpLogin = mkOption {
        type = types.str;
        example = "allyourbase";
        default = "";
        description = lib.mdDoc ''
          HTTP web login username.
        '';
      };

      httpPass = mkOption {
        type = types.str;
        example = "arebelongtous";
        default = "";
        description = lib.mdDoc ''
          HTTP web login password.
        '';
      };

      encryptLAN = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc "Encrypt LAN data.";
      };

      enableWebUI = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enable Web UI for administration. Bound to the specified
          `httpListenAddress` and
          `httpListenPort`.
          '';
      };

      storagePath = mkOption {
        type = types.path;
        default = "/var/lib/resilio-sync/";
        description = lib.mdDoc ''
          Where BitTorrent Sync will store it's database files (containing
          things like username info and licenses). Generally, you should not
          need to ever change this.
        '';
      };

      apiKey = mkOption {
        type = types.str;
        default = "";
        description = lib.mdDoc "API key, which enables the developer API.";
      };

      directoryRoot = mkOption {
        type = types.str;
        default = "";
        example = "/media";
        description = lib.mdDoc "Default directory to add folders in the web UI.";
      };

      sharedFolders = mkOption {
        default = [];
        type = types.listOf (types.attrsOf types.anything);
        example =
          [ { secret         = "AHMYFPCQAHBM7LQPFXQ7WV6Y42IGUXJ5Y";
              directory      = "/home/user/sync_test";
              useRelayServer = true;
              useTracker     = true;
              useDHT         = false;
              searchLAN      = true;
              useSyncTrash   = true;
              knownHosts     = [
                "192.168.1.2:4444"
                "192.168.1.3:4444"
              ];
            }
          ];
        description = lib.mdDoc ''
          Shared folder list. If enabled, web UI must be
          disabled. Secrets can be generated using `rslsync --generate-secret`.
          Note that this secret will be
          put inside the Nix store, so it is realistically not very
          secret.

          If you would like to be able to modify the contents of this
          directories, it is recommended that you make your user a
          member of the `rslsync` group.

          Directories in this list should be in the
          `rslsync` group, and that group must have
          write access to the directory. It is also recommended that
          `chmod g+s` is applied to the directory
          so that any sub directories created will also belong to
          the `rslsync` group. Also,
          `setfacl -d -m group:rslsync:rwx` and
          `setfacl -m group:rslsync:rwx` should also
          be applied so that the sub directories are writable by
          the group.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions =
      [ { assertion = cfg.deviceName != "";
          message   = "Device name cannot be empty.";
        }
        { assertion = cfg.enableWebUI -> cfg.sharedFolders == [];
          message   = "If using shared folders, the web UI cannot be enabled.";
        }
        { assertion = cfg.apiKey != "" -> cfg.enableWebUI;
          message   = "If you're using an API key, you must enable the web server.";
        }
      ];

    users.users.rslsync = {
      description     = "Resilio Sync Service user";
      home            = cfg.storagePath;
      createHome      = true;
      uid             = config.ids.uids.rslsync;
      group           = "rslsync";
    };

    users.groups.rslsync = {};

    systemd.services.resilio = with pkgs; {
      description = "Resilio Sync Service";
      wantedBy    = [ "multi-user.target" ];
      after       = [ "network.target" ];
      serviceConfig = {
        Restart   = "on-abort";
        UMask     = "0002";
        User      = "rslsync";
        ExecStart = ''
          ${resilioSync}/bin/rslsync --nodaemon --config ${configFile}
        '';
      };
    };
  };
}
