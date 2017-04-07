{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.btsync;

  bittorrentSync = cfg.package;

  listenAddr = cfg.httpListenAddr + ":" + (toString cfg.httpListenPort);

  boolStr = x: if x then "true" else "false";
  optionalEmptyStr = b: v: optionalString (b != "") v;

  webUIConfig = optionalString cfg.enableWebUI
    ''
      "webui":
      {
        ${optionalEmptyStr cfg.httpLogin     "\"login\":          \"${cfg.httpLogin}\","}
        ${optionalEmptyStr cfg.httpPass      "\"password\":       \"${cfg.httpPass}\","}
        ${optionalEmptyStr cfg.apiKey        "\"api_key\":        \"${cfg.apiKey}\","}
        ${optionalEmptyStr cfg.directoryRoot "\"directory_root\": \"${cfg.directoryRoot}\","}
        "listen": "${listenAddr}"
      }
    '';

  knownHosts = e:
    optionalString (e ? "knownHosts")
      (concatStringsSep "," (map (v: "\"${v}\"") e."knownHosts"));

  sharedFoldersRecord =
    concatStringsSep "," (map (entry:
      let helper = attr: v:
        if (entry ? attr) then boolStr entry.attr else boolStr v;
      in
      ''
        {
          "secret": "${entry.secret}",
          "dir":    "${entry.directory}",

          "use_relay_server": ${helper "useRelayServer" true},
          "use_tracker":      ${helper "useTracker"     true},
          "use_dht":          ${helper "useDHT"        false},

          "search_lan":       ${helper "searchLAN"      true},
          "use_sync_trash":   ${helper "useSyncTrash"   true},

          "known_hosts": [${knownHosts entry}]
        }
      '') cfg.sharedFolders);

  sharedFoldersConfig = optionalString (cfg.sharedFolders != [])
    ''
      "shared_folders":
        [
        ${sharedFoldersRecord}
        ]
    '';

  configFile = pkgs.writeText "btsync.config"
    ''
      {
        "device_name":     "${cfg.deviceName}",
        "storage_path":    "${cfg.storagePath}",
        "listening_port":  ${toString cfg.listeningPort},
        "use_gui":         false,

        "check_for_updates": ${boolStr cfg.checkForUpdates},
        "use_upnp":          ${boolStr cfg.useUpnp},
        "download_limit":    ${toString cfg.downloadLimit},
        "upload_limit":      ${toString cfg.uploadLimit},
        "lan_encrypt_data":  ${boolStr cfg.encryptLAN},

        ${webUIConfig}
        ${sharedFoldersConfig}
      }
    '';
in
{
  options = {
    services.btsync = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If enabled, start the Bittorrent Sync daemon. Once enabled, you can
          interact with the service through the Web UI, or configure it in your
          NixOS configuration. Enabling the <literal>btsync</literal> service
          also installs a systemd user unit which can be used to start
          user-specific copies of the daemon. Once installed, you can use
          <literal>systemctl --user start btsync</literal> as your user to start
          the daemon using the configuration file located at
          <literal>$HOME/.config/btsync.conf</literal>.
        '';
      };

      deviceName = mkOption {
        type = types.str;
        example = "Voltron";
        description = ''
          Name of the Bittorrent Sync device.
        '';
      };

      listeningPort = mkOption {
        type = types.int;
        default = 0;
        example = 44444;
        description = ''
          Listening port. Defaults to 0 which randomizes the port.
        '';
      };

      checkForUpdates = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Determines whether to check for updates and alert the user
          about them in the UI.
        '';
      };

      useUpnp = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Use Universal Plug-n-Play (UPnP)
        '';
      };

      downloadLimit = mkOption {
        type = types.int;
        default = 0;
        example = 1024;
        description = ''
          Download speed limit. 0 is unlimited (default).
        '';
      };

      uploadLimit = mkOption {
        type = types.int;
        default = 0;
        example = 1024;
        description = ''
          Upload speed limit. 0 is unlimited (default).
        '';
      };

      httpListenAddr = mkOption {
        type = types.str;
        default = "0.0.0.0";
        example = "1.2.3.4";
        description = ''
          HTTP address to bind to.
        '';
      };

      httpListenPort = mkOption {
        type = types.int;
        default = 9000;
        description = ''
          HTTP port to bind on.
        '';
      };

      httpLogin = mkOption {
        type = types.str;
        example = "allyourbase";
        default = "";
        description = ''
          HTTP web login username.
        '';
      };

      httpPass = mkOption {
        type = types.str;
        example = "arebelongtous";
        default = "";
        description = ''
          HTTP web login password.
        '';
      };

      encryptLAN = mkOption {
        type = types.bool;
        default = true;
        description = "Encrypt LAN data.";
      };

      enableWebUI = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable Web UI for administration. Bound to the specified
          <literal>httpListenAddress</literal> and
          <literal>httpListenPort</literal>.
          '';
      };

      package = mkOption {
        type = types.package;
        example = literalExample "pkgs.bittorrentSync20";
        description = ''
          Branch of bittorrent sync to use.
        '';
      };

      storagePath = mkOption {
        type = types.path;
        default = "/var/lib/btsync/";
        description = ''
          Where BitTorrent Sync will store it's database files (containing
          things like username info and licenses). Generally, you should not
          need to ever change this.
        '';
      };

      apiKey = mkOption {
        type = types.str;
        default = "";
        description = "API key, which enables the developer API.";
      };

      directoryRoot = mkOption {
        type = types.str;
        default = "";
        example = "/media";
        description = "Default directory to add folders in the web UI.";
      };

      sharedFolders = mkOption {
        default = [];
        example =
          [ { secret         = "AHMYFPCQAHBM7LQPFXQ7WV6Y42IGUXJ5Y";
              directory      = "/home/user/sync_test";
              useRelayServer = true;
              useTracker     = true;
              useDHT         = false;
              searchLAN      = true;
              useSyncTrash   = true;
              knownHosts     =
                [ "192.168.1.2:4444"
                  "192.168.1.3:4444"
                ];
            }
          ];
        description = ''
          Shared folder list. If enabled, web UI must be
          disabled. Secrets can be generated using <literal>btsync
          --generate-secret</literal>. Note that this secret will be
          put inside the Nix store, so it is realistically not very
          secret.

          If you would like to be able to modify the contents of this
          directories, it is recommended that you make your user a
          member of the <literal>btsync</literal> group.

          Directories in this list should be in the
          <literal>btsync</literal> group, and that group must have
          write access to the directory. It is also recommended that
          <literal>chmod g+s</literal> is applied to the directory
          so that any sub directories created will also belong to
          the <literal>btsync</literal> group. Also,
          <literal>setfacl -d -m group:btsync:rwx</literal> and
          <literal>setfacl -m group:btsync:rwx</literal> should also
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

    services.btsync.package = mkOptionDefault pkgs.bittorrentSync14;

    users.extraUsers.btsync = {
      description     = "Bittorrent Sync Service user";
      home            = cfg.storagePath;
      createHome      = true;
      uid             = config.ids.uids.btsync;
      group           = "btsync";
    };

    users.extraGroups = [
      { name = "btsync";
      }];

    systemd.services.btsync = with pkgs; {
      description = "Bittorrent Sync Service";
      wantedBy    = [ "multi-user.target" ];
      after       = [ "network.target" "local-fs.target" ];
      serviceConfig = {
        Restart   = "on-abort";
        UMask     = "0002";
        User      = "btsync";
        ExecStart =
          "${bittorrentSync}/bin/btsync --nodaemon --config ${configFile}";
      };
    };

    systemd.user.services.btsync = with pkgs; {
      description = "Bittorrent Sync user service";
      after       = [ "network.target" "local-fs.target" ];
      serviceConfig = {
        Restart   = "on-abort";
        ExecStart =
          "${bittorrentSync}/bin/btsync --nodaemon --config %h/.config/btsync.conf";
      };
    };

    environment.systemPackages = [ cfg.package ];
  };
}
