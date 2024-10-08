{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.jitsi-meet;

  # The configuration files are JS of format "var <<string>> = <<JSON>>;". In order to
  # override only some settings, we need to extract the JSON, use jq to merge it with
  # the config provided by user, and then reconstruct the file.
  overrideJs =
    source: varName: userCfg: appendExtra:
    let
      extractor = pkgs.writeText "extractor.js" ''
        var fs = require("fs");
        eval(fs.readFileSync(process.argv[2], 'utf8'));
        process.stdout.write(JSON.stringify(eval(process.argv[3])));
      '';
      userJson = pkgs.writeText "user.json" (builtins.toJSON userCfg);
    in (pkgs.runCommand "${varName}.js" { } ''
      ${pkgs.nodejs}/bin/node ${extractor} ${source} ${varName} > default.json
      (
        echo "var ${varName} = "
        ${pkgs.jq}/bin/jq -s '.[0] * .[1]' default.json ${userJson}
        echo ";"
        echo ${escapeShellArg appendExtra}
      ) > $out
    '');

  # Essential config - it's probably not good to have these as option default because
  # types.attrs doesn't do merging. Let's merge explicitly, can still be overridden if
  # user desires.
  defaultCfg = {
    hosts = {
      domain = cfg.hostName;
      muc = "conference.${cfg.hostName}";
      focus = "focus.${cfg.hostName}";
      jigasi = "jigasi.${cfg.hostName}";
    };
    bosh = "//${cfg.hostName}/http-bind";
    websocket = "wss://${cfg.hostName}/xmpp-websocket";

    fileRecordingsEnabled = true;
    liveStreamingEnabled = true;
    hiddenDomain = "recorder.${cfg.hostName}";
  };
in
{
  options.services.jitsi-meet = with types; {
    enable = mkEnableOption "Jitsi Meet - Secure, Simple and Scalable Video Conferences";

    hostName = mkOption {
      type = str;
      example = "meet.example.org";
      description = ''
        FQDN of the Jitsi Meet instance.
      '';
    };

    config = mkOption {
      type = attrs;
      default = { };
      example = literalExpression ''
        {
          enableWelcomePage = false;
          defaultLang = "fi";
        }
      '';
      description = ''
        Client-side web application settings that override the defaults in {file}`config.js`.

        See <https://github.com/jitsi/jitsi-meet/blob/master/config.js> for default
        configuration with comments.
      '';
    };

    extraConfig = mkOption {
      type = lines;
      default = "";
      description = ''
        Text to append to {file}`config.js` web application config file.

        Can be used to insert JavaScript logic to determine user's region in cascading bridges setup.
      '';
    };

    interfaceConfig = mkOption {
      type = attrs;
      default = { };
      example = literalExpression ''
        {
          SHOW_JITSI_WATERMARK = false;
          SHOW_WATERMARK_FOR_GUESTS = false;
        }
      '';
      description = ''
        Client-side web-app interface settings that override the defaults in {file}`interface_config.js`.

        See <https://github.com/jitsi/jitsi-meet/blob/master/interface_config.js> for
        default configuration with comments.
      '';
    };

    videobridge = {
      enable = mkOption {
        type = bool;
        default = true;
        description = ''
          Jitsi Videobridge instance and configure it to connect to Prosody.

          Additional configuration is possible with {option}`services.jitsi-videobridge`
        '';
      };

      passwordFile = mkOption {
        type = nullOr str;
        default = null;
        example = "/run/keys/videobridge";
        description = ''
          File containing password to the Prosody account for videobridge.

          If `null`, a file with password will be generated automatically. Setting
          this option is useful if you plan to connect additional videobridges to the XMPP server.
        '';
      };
    };

    jicofo.enable = mkOption {
      type = bool;
      default = true;
      description = ''
        Whether to enable JiCoFo instance and configure it to connect to Prosody.

        Additional configuration is possible with {option}`services.jicofo`.
      '';
    };

    jibri.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Whether to enable a Jibri instance and configure it to connect to Prosody.

        Additional configuration is possible with {option}`services.jibri`, and
        {option}`services.jibri.finalizeScript` is especially useful.
      '';
    };

    jigasi.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Whether to enable jigasi instance and configure it to connect to Prosody.

        Additional configuration is possible with <option>services.jigasi</option>.
      '';
    };

    nginx.enable = mkOption {
      type = bool;
      default = true;
      description = ''
        Whether to enable nginx virtual host that will serve the javascript application and act as
        a proxy for the XMPP server. Further nginx configuration can be done by adapting
        {option}`services.nginx.virtualHosts.<hostName>`.
        When this is enabled, ACME will be used to retrieve a TLS certificate by default. To disable
        this, set the {option}`services.nginx.virtualHosts.<hostName>.enableACME` to
        `false` and if appropriate do the same for
        {option}`services.nginx.virtualHosts.<hostName>.forceSSL`.
      '';
    };

    caddy.enable = mkEnableOption "caddy reverse proxy to expose jitsi-meet";

    prosody.enable = mkOption {
      type = bool;
      default = true;
      example = false;
      description = ''
        Whether to configure Prosody to relay XMPP messages between Jitsi Meet components. Turn this
        off if you want to configure it manually.
      '';
    };
    prosody.lockdown = mkOption {
      type = bool;
      default = false;
      example = true;
      description = ''
        Whether to disable Prosody features not needed by Jitsi Meet.

        The default Prosody configuration assumes that it will be used as a
        general-purpose XMPP server rather than as a companion service for
        Jitsi Meet. This option reconfigures Prosody to only listen on
        localhost without support for TLS termination, XMPP federation or
        the file transfer proxy.
      '';
    };

    excalidraw.enable = mkEnableOption "Excalidraw collaboration backend for Jitsi";
    excalidraw.port = mkOption {
      type = types.port;
      default = 3002;
      description = ''The port which the Excalidraw backend for Jitsi should listen to.'';
    };

    secureDomain = {
      enable = mkEnableOption "Authenticated room creation";
      authentication = mkOption {
        type = types.str;
        default = "internal_hashed";
        description = ''The authentication type to be used by jitsi'';
      };
    };
  };

  config = mkIf cfg.enable {
    services.prosody = mkIf cfg.prosody.enable {
      enable = mkDefault true;
      xmppComplianceSuite = mkDefault false;
      modules = {
        admin_adhoc = mkDefault false;
        bosh = mkDefault true;
        ping = mkDefault true;
        roster = mkDefault true;
        saslauth = mkDefault true;
        smacks = mkDefault true;
        tls = mkDefault true;
        websocket = mkDefault true;
        proxy65 = mkIf cfg.prosody.lockdown (mkDefault false);
      };
      httpInterfaces = mkIf cfg.prosody.lockdown (mkDefault [ "127.0.0.1" ]);
      httpsPorts = mkIf cfg.prosody.lockdown (mkDefault []);
      muc = [
        {
          domain = "conference.${cfg.hostName}";
          name = "Jitsi Meet MUC";
          roomLocking = false;
          roomDefaultPublicJids = true;
          extraConfig = ''
            restrict_room_creation = true
            storage = "memory"
            admins = { "focus@auth.${cfg.hostName}" }
          '';
        }
        {
          domain = "breakout.${cfg.hostName}";
          name = "Jitsi Meet Breakout MUC";
          roomLocking = false;
          roomDefaultPublicJids = true;
          extraConfig = ''
            restrict_room_creation = true
            storage = "memory"
            admins = { "focus@auth.${cfg.hostName}", "jvb@auth.${cfg.hostName}" }
          '';
        }
        {
          domain = "internal.auth.${cfg.hostName}";
          name = "Jitsi Meet Videobridge MUC";
          roomLocking = false;
          roomDefaultPublicJids = true;
          extraConfig = ''
            storage = "memory"
            admins = { "focus@auth.${cfg.hostName}", "jvb@auth.${cfg.hostName}", "jigasi@auth.${cfg.hostName}" }
          '';
          #-- muc_room_cache_size = 1000
        }
        {
          domain = "lobby.${cfg.hostName}";
          name = "Jitsi Meet Lobby MUC";
          roomLocking = false;
          roomDefaultPublicJids = true;
          extraConfig = ''
            restrict_room_creation = true
            storage = "memory"
          '';
        }
      ];
      extraModules = [
        "pubsub"
        "smacks"
        "speakerstats"
        "external_services"
        "conference_duration"
        "end_conference"
        "muc_lobby_rooms"
        "muc_breakout_rooms"
        "av_moderation"
        "muc_hide_all"
        "muc_meeting_id"
        "muc_domain_mapper"
        "muc_rate_limit"
        "limits_exception"
        "persistent_lobby"
        "room_metadata"
      ];
      extraPluginPaths = [ "${pkgs.jitsi-meet-prosody}/share/prosody-plugins" ];
      extraConfig = lib.mkMerge [
        (mkAfter ''
          Component "focus.${cfg.hostName}" "client_proxy"
            target_address = "focus@auth.${cfg.hostName}"

          Component "jigasi.${cfg.hostName}" "client_proxy"
            target_address = "jigasi@auth.${cfg.hostName}"

          Component "speakerstats.${cfg.hostName}" "speakerstats_component"
            muc_component = "conference.${cfg.hostName}"

          Component "conferenceduration.${cfg.hostName}" "conference_duration_component"
            muc_component = "conference.${cfg.hostName}"

          Component "endconference.${cfg.hostName}" "end_conference"
            muc_component = "conference.${cfg.hostName}"

          Component "avmoderation.${cfg.hostName}" "av_moderation_component"
            muc_component = "conference.${cfg.hostName}"

          Component "metadata.${cfg.hostName}" "room_metadata_component"
            muc_component = "conference.${cfg.hostName}"
            breakout_rooms_component = "breakout.${cfg.hostName}"
        '')
        (mkBefore (''
          muc_mapper_domain_base = "${cfg.hostName}"

          cross_domain_websocket = true;
          consider_websocket_secure = true;

          unlimited_jids = {
            "focus@auth.${cfg.hostName}",
            "jvb@auth.${cfg.hostName}"
          }
        '' + optionalString cfg.prosody.lockdown ''
          c2s_interfaces = { "127.0.0.1" };
          modules_disabled = { "s2s" };
        ''))
      ];
      virtualHosts.${cfg.hostName} = {
        enabled = true;
        domain = cfg.hostName;
        extraConfig = ''
          authentication = ${if cfg.secureDomain.enable then "\"${cfg.secureDomain.authentication}\"" else "\"jitsi-anonymous\""}
          c2s_require_encryption = false
          admins = { "focus@auth.${cfg.hostName}" }
          smacks_max_unacked_stanzas = 5
          smacks_hibernation_time = 60
          smacks_max_hibernated_sessions = 1
          smacks_max_old_sessions = 1

          av_moderation_component = "avmoderation.${cfg.hostName}"
          speakerstats_component = "speakerstats.${cfg.hostName}"
          conference_duration_component = "conferenceduration.${cfg.hostName}"
          end_conference_component = "endconference.${cfg.hostName}"

          c2s_require_encryption = false
          lobby_muc = "lobby.${cfg.hostName}"
          breakout_rooms_muc = "breakout.${cfg.hostName}"
          room_metadata_component = "metadata.${cfg.hostName}"
          main_muc = "conference.${cfg.hostName}"
        '';
        ssl = {
          cert = "/var/lib/jitsi-meet/jitsi-meet.crt";
          key = "/var/lib/jitsi-meet/jitsi-meet.key";
        };
      };
      virtualHosts."auth.${cfg.hostName}" = {
        enabled = true;
        domain = "auth.${cfg.hostName}";
        extraConfig = ''
          authentication = "internal_hashed"
        '';
        ssl = {
          cert = "/var/lib/jitsi-meet/jitsi-meet.crt";
          key = "/var/lib/jitsi-meet/jitsi-meet.key";
        };
      };
      virtualHosts."recorder.${cfg.hostName}" = {
        enabled = true;
        domain = "recorder.${cfg.hostName}";
        extraConfig = ''
          authentication = "internal_plain"
          c2s_require_encryption = false
        '';
      };
      virtualHosts."guest.${cfg.hostName}" = {
        enabled = true;
        domain = "guest.${cfg.hostName}";
        extraConfig = ''
          authentication = "anonymous"
          c2s_require_encryption = false
        '';
      };
    };
    systemd.services.prosody = mkIf cfg.prosody.enable {
      preStart = let
        videobridgeSecret = if cfg.videobridge.passwordFile != null then cfg.videobridge.passwordFile else "/var/lib/jitsi-meet/videobridge-secret";
      in ''
        ${config.services.prosody.package}/bin/prosodyctl register focus auth.${cfg.hostName} "$(cat /var/lib/jitsi-meet/jicofo-user-secret)"
        ${config.services.prosody.package}/bin/prosodyctl register jvb auth.${cfg.hostName} "$(cat ${videobridgeSecret})"
        ${config.services.prosody.package}/bin/prosodyctl mod_roster_command subscribe focus.${cfg.hostName} focus@auth.${cfg.hostName}
        ${config.services.prosody.package}/bin/prosodyctl register jibri auth.${cfg.hostName} "$(cat /var/lib/jitsi-meet/jibri-auth-secret)"
        ${config.services.prosody.package}/bin/prosodyctl register recorder recorder.${cfg.hostName} "$(cat /var/lib/jitsi-meet/jibri-recorder-secret)"
      '' + optionalString cfg.jigasi.enable ''
        ${config.services.prosody.package}/bin/prosodyctl register jigasi auth.${cfg.hostName} "$(cat /var/lib/jitsi-meet/jigasi-user-secret)"
      '';

      serviceConfig = {
        EnvironmentFile = [ "/var/lib/jitsi-meet/secrets-env" ];
        SupplementaryGroups = [ "jitsi-meet" ];
      };
      reloadIfChanged = true;
    };

    users.groups.jitsi-meet = { };
    systemd.tmpfiles.rules = [
      "d '/var/lib/jitsi-meet' 0750 root jitsi-meet - -"
    ];

    systemd.services.jitsi-meet-init-secrets = {
      wantedBy = [ "multi-user.target" ];
      before = [ "jicofo.service" "jitsi-videobridge2.service" ] ++ (optional cfg.prosody.enable "prosody.service") ++ (optional cfg.jigasi.enable "jigasi.service");
      serviceConfig = {
        Type = "oneshot";
        UMask = "027";
        User = "root";
        Group = "jitsi-meet";
        WorkingDirectory = "/var/lib/jitsi-meet";
      };

      script = let
        secrets = [ "jicofo-component-secret" "jicofo-user-secret" "jibri-auth-secret" "jibri-recorder-secret" ] ++ (optionals cfg.jigasi.enable [ "jigasi-user-secret" "jigasi-component-secret" ]) ++ (optional (cfg.videobridge.passwordFile == null) "videobridge-secret");
      in
      ''
        ${concatMapStringsSep "\n" (s: ''
          if [ ! -f ${s} ]; then
            tr -dc a-zA-Z0-9 </dev/urandom | head -c 64 > ${s}
          fi
        '') secrets}

        # for easy access in prosody
        echo "JICOFO_COMPONENT_SECRET=$(cat jicofo-component-secret)" > secrets-env
        echo "JIGASI_COMPONENT_SECRET=$(cat jigasi-component-secret)" >> secrets-env
      ''
      + optionalString cfg.prosody.enable ''
        # generate self-signed certificates
        if [ ! -f /var/lib/jitsi-meet/jitsi-meet.crt ]; then
          ${getBin pkgs.openssl}/bin/openssl req \
            -x509 \
            -newkey rsa:4096 \
            -keyout /var/lib/jitsi-meet/jitsi-meet.key \
            -out /var/lib/jitsi-meet/jitsi-meet.crt \
            -days 36500 \
            -nodes \
            -subj '/CN=${cfg.hostName}/CN=auth.${cfg.hostName}'
          chmod 640 /var/lib/jitsi-meet/jitsi-meet.key
        fi
      '';
    };

    systemd.services.jitsi-excalidraw = mkIf cfg.excalidraw.enable {
      description = "Excalidraw collaboration backend for Jitsi";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment.PORT = toString cfg.excalidraw.port;

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.jitsi-excalidraw}/bin/jitsi-excalidraw-backend";
        Restart = "on-failure";

        DynamicUser = true;
        Group = "jitsi-meet";
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectClock = true;
        ProtectHome = true;
        ProtectProc = true;
        ProtectKernelLogs = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectHostname = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallFilter = [ "@system-service @pkey" "~@privileged" ];
      };
    };

    services.nginx = mkIf cfg.nginx.enable {
      enable = mkDefault true;
      virtualHosts.${cfg.hostName} = {
        enableACME = mkDefault true;
        forceSSL = mkDefault true;
        root = pkgs.jitsi-meet;
        extraConfig = ''
          ssi on;
        '';
        locations."@root_path".extraConfig = ''
          rewrite ^/(.*)$ / break;
        '';
        locations."~ ^/([^/\\?&:'\"]+)$".tryFiles = "$uri @root_path";
        locations."^~ /xmpp-websocket" = {
          priority = 100;
          proxyPass = "http://localhost:5280/xmpp-websocket";
          proxyWebsockets = true;
        };
        locations."=/http-bind" = {
          proxyPass = "http://localhost:5280/http-bind";
          extraConfig = ''
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $host;
          '';
        };
        locations."=/external_api.js" = mkDefault {
          alias = "${pkgs.jitsi-meet}/libs/external_api.min.js";
        };
        locations."=/_api/room-info" = {
          proxyPass = "http://localhost:5280/room-info";
          extraConfig = ''
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $host;
          '';
        };
        locations."=/config.js" = mkDefault {
          alias = overrideJs "${pkgs.jitsi-meet}/config.js" "config" (recursiveUpdate defaultCfg cfg.config) cfg.extraConfig;
        };
        locations."=/interface_config.js" = mkDefault {
          alias = overrideJs "${pkgs.jitsi-meet}/interface_config.js" "interfaceConfig" cfg.interfaceConfig "";
        };
        locations."/socket.io/" = mkIf cfg.excalidraw.enable {
          proxyPass = "http://127.0.0.1:${toString cfg.excalidraw.port}";
          proxyWebsockets = true;
        };
      };
    };

    services.caddy = mkIf cfg.caddy.enable {
      enable = mkDefault true;
      virtualHosts.${cfg.hostName} = {
        extraConfig =
        let
          templatedJitsiMeet = pkgs.runCommand "templated-jitsi-meet" { } ''
            cp -R --no-preserve=all ${pkgs.jitsi-meet}/* .
            for file in *.html **/*.html ; do
              ${pkgs.sd}/bin/sd '<!--#include virtual="(.*)" -->' '{{ include "$1" }}' $file
            done
            rm config.js
            rm interface_config.js
            cp -R . $out
            cp ${overrideJs "${pkgs.jitsi-meet}/config.js" "config" (recursiveUpdate defaultCfg cfg.config) cfg.extraConfig} $out/config.js
            cp ${overrideJs "${pkgs.jitsi-meet}/interface_config.js" "interfaceConfig" cfg.interfaceConfig ""} $out/interface_config.js
            cp ./libs/external_api.min.js $out/external_api.js
          '';
        in (optionalString cfg.excalidraw.enable ''
          handle /socket.io/ {
            reverse_proxy 127.0.0.1:${toString cfg.excalidraw.port}
          }
        '') + ''
          handle /http-bind {
            header Host ${cfg.hostName}
            reverse_proxy 127.0.0.1:5280
          }
          handle /xmpp-websocket {
            reverse_proxy 127.0.0.1:5280
          }
          handle {
            templates
            root * ${templatedJitsiMeet}
            try_files {path} {path}
            try_files {path} /index.html
            file_server
          }
        '';
      };
    };

    services.jitsi-meet.config = recursiveUpdate
      (mkIf cfg.excalidraw.enable {
        whiteboard = {
          enabled = true;
          collabServerBaseUrl = "https://${cfg.hostName}";
        };
      })
      (mkIf cfg.secureDomain.enable {
        hosts.anonymousdomain = "guest.${cfg.hostName}";
      });

    services.jitsi-videobridge = mkIf cfg.videobridge.enable {
      enable = true;
      xmppConfigs."localhost" = {
        userName = "jvb";
        domain = "auth.${cfg.hostName}";
        passwordFile = "/var/lib/jitsi-meet/videobridge-secret";
        mucJids = "jvbbrewery@internal.auth.${cfg.hostName}";
        disableCertificateVerification = true;
      };
    };

    services.jicofo = mkIf cfg.jicofo.enable {
      enable = true;
      xmppHost = "localhost";
      xmppDomain = cfg.hostName;
      userDomain = "auth.${cfg.hostName}";
      userName = "focus";
      userPasswordFile = "/var/lib/jitsi-meet/jicofo-user-secret";
      componentPasswordFile = "/var/lib/jitsi-meet/jicofo-component-secret";
      bridgeMuc = "jvbbrewery@internal.auth.${cfg.hostName}";
      config = mkMerge [{
        jicofo.xmpp.service.disable-certificate-verification = true;
        jicofo.xmpp.client.disable-certificate-verification = true;
      }
        (lib.mkIf (config.services.jibri.enable || cfg.jibri.enable) {
          jicofo.jibri = {
            brewery-jid = "JibriBrewery@internal.auth.${cfg.hostName}";
            pending-timeout = "90";
          };
        })
        (lib.mkIf cfg.secureDomain.enable {
          jicofo = {
            authentication = {
              enabled = "true";
              type = "XMPP";
              login-url = cfg.hostName;
            };
            xmpp.client.client-proxy = "focus.${cfg.hostName}";
          };
        })];
    };

    services.jibri = mkIf cfg.jibri.enable {
      enable = true;

      xmppEnvironments."jitsi-meet" = {
        xmppServerHosts = [ "localhost" ];
        xmppDomain = cfg.hostName;

        control.muc = {
          domain = "internal.auth.${cfg.hostName}";
          roomName = "JibriBrewery";
          nickname = "jibri";
        };

        control.login = {
          domain = "auth.${cfg.hostName}";
          username = "jibri";
          passwordFile = "/var/lib/jitsi-meet/jibri-auth-secret";
        };

        call.login = {
          domain = "recorder.${cfg.hostName}";
          username = "recorder";
          passwordFile = "/var/lib/jitsi-meet/jibri-recorder-secret";
        };

        usageTimeout = "0";
        disableCertificateVerification = true;
        stripFromRoomDomain = "conference.";
      };
    };

    services.jigasi = mkIf cfg.jigasi.enable {
      enable = true;
      xmppHost = "localhost";
      xmppDomain = cfg.hostName;
      userDomain = "auth.${cfg.hostName}";
      userName = "jigasi";
      userPasswordFile = "/var/lib/jitsi-meet/jigasi-user-secret";
      componentPasswordFile = "/var/lib/jitsi-meet/jigasi-component-secret";
      bridgeMuc = "jigasibrewery@internal.${cfg.hostName}";
      config = {
        "org.jitsi.jigasi.ALWAYS_TRUST_MODE_ENABLED" = "true";
      };
    };
  };

  meta.doc = ./jitsi-meet.md;
  meta.maintainers = lib.teams.jitsi.members;
}
