{ config, pkgs, ... }:

with pkgs.lib;

let
  cfg = config.services.btsync;
  listenAddr = cfg.httpListenAddr + ":" + (toString cfg.httpListenPort);

  boolStr = x: if x then "true" else "false";
  optionalEmptyStr = b: v: optionalString (b != "") v;

  webUIConfig = optionalString cfg.enableWebUI
    ''
      "webui":
      {
        ${optionalEmptyStr cfg.httpLogin "\"login\":    \"${cfg.httpLogin}\","}
        ${optionalEmptyStr cfg.httpPass  "\"password\": \"${cfg.httpPass}\","}
        ${optionalEmptyStr cfg.apiKey    "\"api_key\":  \"${cfg.apiKey}\","}
        "listen": "${listenAddr}"
      }
    '';

  knownHosts = e:
    optionalString (e ? "knownHosts")
      (concatStringsSep "," (map (v: "\"${v}\"") e."knownHosts"));

  sharedFoldersRecord = with pkgs.lib;
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
        "storage_path":    "/var/lib/btsync",
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
          If enabled, start the Bittorrent Sync daemon. Once enabled,
          you can interact with the service through the Web UI, or
          configure it in your NixOS configuration. Enabling the
          <literal>btsync</literal> service also installs a
          multi-instance systemd unit which can be used to start
          user-specific copies of the daemon. Once installed, you can
          use <literal>systemctl start btsync@user</literal> to start
          the daemon only for user <literal>user</literal>, using the
          configuration file located at
          <literal>$HOME/.config/btsync.conf</literal>
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
        description = ''
          HTTP web login username.
        '';
      };

      httpPass = mkOption {
        type = types.str;
        example = "arebelongtous";
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

      apiKey = mkOption {
        type = types.str;
        default = "";
        description = "API key, which enables the developer API.";
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
        # TODO FIXME: the README says not specifying the login/pass means it
        # should disable authentication, but apparently it doesn't?
        { assertion = cfg.enableWebUI -> cfg.httpLogin != "" && cfg.httpPass != "";
          message   = "If using the web UI, you must configure a login/password.";
        }
        # TODO FIXME: assert the existence of sharedFolder directories?
      ];

    users.extraUsers.btsync = {
      description     = "Bittorrent Sync Service user";
      home            = "/var/lib/btsync";
      createHome      = true;
      uid             = config.ids.uids.btsync;
    };

    systemd.services.btsync = with pkgs; {
      description = "Bittorrent Sync Service";
      wantedBy    = [ "multi-user.target" ];
      after       = [ "network.target" ];
      serviceConfig = {
        Restart   = "on-abort";
        User      = "btsync";
        ExecStart =
          "${bittorrentSync}/bin/btsync --nodaemon --config ${configFile}";
      };
    };

    systemd.services."btsync@" = with pkgs; {
      description = "Bittorrent Sync Service for %i";
      after       = [ "network.target" ];
      serviceConfig = {
        Restart   = "on-abort";
        User      = "%i";
        ExecStart =
          "${bittorrentSync}/bin/btsync --nodaemon --config %h/.config/btsync.conf";
      };
    };

    environment.systemPackages = [ pkgs.bittorrentSync ];
  };
}
