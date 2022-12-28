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
    authdomain = if cfg.jwt.enable then cfg.hostName else null;
    hosts = {
      domain = cfg.hostName;
      muc = "conference.${cfg.hostName}";
      focus = "focus.${cfg.hostName}";
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
    enable = mkEnableOption (lib.mdDoc "Jitsi Meet - Secure, Simple and Scalable Video Conferences");

    hostName = mkOption {
      type = str;
      example = "meet.example.org";
      description = lib.mdDoc ''
        FQDN of the Jitsi Meet instance.
      '';
    };

    jwt = {
      enable = mkOption {
        type = bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable JWT authentication.

          This will automatically set services.prosody.authentication = "token" and generate a JWT secret.
        '';
      };
      verifyDomain = mkOption {
        type = bool;
        default = true;
        description = lib.mdDoc ''
          True if we should verify the domain.
        '';
      };
      appId = mkOption {
        type = nullOr str;
        default = null;
        example = "jitsi.example.com";
        description = lib.mdDoc ''
          The application ID issuing JWTs. Usually equal to the domain name.
        '';
      };
      issuer = mkOption {
        type = nullOr str;
        default = null;
        example = "issuer.example.com";
        description = lib.mdDoc ''
          Set to the desired JWT issuer if you want Prosody to verify the JWT issuers too.
        '';
      };
      audience = mkOption {
        type = nullOr str;
        default = null;
        example = "issuer.example.com";
        description = lib.mdDoc ''
          Set to the desired JWT audience if you want Prosody to verify the JWT audiences too.
          Frequently equal to the issuer.
        '';
      };
      secretFile = mkOption {
        type = nullOr (either string (either package path));
        default = null;
        example = "/run/keys/jitsi";
        description = lib.mdDoc ''
          File containing a secret to read for JWT authentication. If provided, must be populated manually.
          A random alphanumeric string of 64 characters is ideal.
        '';
      };
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
      description = lib.mdDoc ''
        Client-side web application settings that override the defaults in {file}`config.js`.

        See <https://github.com/jitsi/jitsi-meet/blob/master/config.js> for default
        configuration with comments.
      '';
    };

    extraConfig = mkOption {
      type = lines;
      default = "";
      description = lib.mdDoc ''
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
      description = lib.mdDoc ''
        Client-side web-app interface settings that override the defaults in {file}`interface_config.js`.

        See <https://github.com/jitsi/jitsi-meet/blob/master/interface_config.js> for
        default configuration with comments.
      '';
    };

    videobridge = {
      enable = mkOption {
        type = bool;
        default = true;
        description = lib.mdDoc ''
          Whether to enable Jitsi Videobridge instance and configure it to connect to Prosody.

          Additional configuration is possible with {option}`services.jitsi-videobridge`.
        '';
      };

      passwordFile = mkOption {
        type = nullOr str;
        default = null;
        example = "/run/keys/videobridge";
        description = lib.mdDoc ''
          File containing password to the Prosody account for videobridge.

          If `null`, a file with password will be generated automatically. Setting
          this option is useful if you plan to connect additional videobridges to the XMPP server.
        '';
      };
    };

    jicofo.enable = mkOption {
      type = bool;
      default = true;
      description = lib.mdDoc ''
        Whether to enable JiCoFo instance and configure it to connect to Prosody.

        Additional configuration is possible with {option}`services.jicofo`.
      '';
    };

    jibri.enable = mkOption {
      type = bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable a Jibri instance and configure it to connect to Prosody.

        Additional configuration is possible with {option}`services.jibri`, and
        {option}`services.jibri.finalizeScript` is especially useful.
      '';
    };

    nginx.enable = mkOption {
      type = bool;
      default = true;
      description = lib.mdDoc ''
        Whether to enable nginx virtual host that will serve the javascript application and act as
        a proxy for the XMPP server. Further nginx configuration can be done by adapting
        {option}`services.nginx.virtualHosts.<hostName>`.
        When this is enabled, ACME will be used to retrieve a TLS certificate by default. To disable
        this, set the {option}`services.nginx.virtualHosts.<hostName>.enableACME` to
        `false` and if appropriate do the same for
        {option}`services.nginx.virtualHosts.<hostName>.forceSSL`.
      '';
    };

    caddy.enable = mkEnableOption (lib.mdDoc "Whether to enable caddy reverse proxy to expose jitsi-meet");

    prosody.enable = mkOption {
      type = bool;
      default = true;
      description = lib.mdDoc ''
        Whether to configure Prosody to relay XMPP messages between Jitsi Meet components. Turn this
        off if you want to configure it manually.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.prosody = mkIf cfg.prosody.enable {
      enable = mkDefault true;
      authentication = mkIf cfg.jwt.enable "token";
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
      };
      muc = [
        {
          domain = "conference.${cfg.hostName}";
          name = "Jitsi Meet MUC";
          roomLocking = false;
          roomDefaultPublicJids = true;
          extraConfig = lib.mkMerge [
            (mkBefore ''
              storage = "memory"
            '')
            (mkIf cfg.jwt.enable ''
              modules_enabled = { "token_verification" }
            '')
          ];
        }
        {
          domain = "internal.${cfg.hostName}";
          name = "Jitsi Meet Videobridge MUC";
          extraConfig = ''
            storage = "memory"
            admins = { "focus@auth.${cfg.hostName}", "jvb@auth.${cfg.hostName}" }
          '';
          #-- muc_room_cache_size = 1000
        }
      ];
      extraModules = [ "pubsub" "smacks" ];
      extraPluginPaths = [ "${pkgs.jitsi-meet-prosody}/share/prosody-plugins" ];
      extraConfig = lib.mkMerge [
        (mkBefore ''
          cross_domain_websocket = true;
          consider_websocket_secure = true;
        '')
        (mkIf cfg.jwt.enable ''
          app_id = "${cfg.jwt.appId}"
          app_secret = os.getenv('JITSI_JWT_SECRET') or ""
        '')
        (mkAfter ''
          Component "focus.${cfg.hostName}" "client_proxy"
            target_address = "focus@auth.${cfg.hostName}"
        '')
      ];
      virtualHosts.${cfg.hostName} = {
        enabled = true;
        domain = cfg.hostName;
        extraConfig = lib.mkMerge [
          (mkBefore ''
            authentication = "${if cfg.jwt.enable then "token" else "anonymous"}"
            c2s_require_encryption = false
            admins = { "focus@auth.${cfg.hostName}" }
            smacks_max_unacked_stanzas = 5
            smacks_hibernation_time = 60
            smacks_max_hibernated_sessions = 1
            smacks_max_old_sessions = 1
          '')
          (mkIf cfg.jwt.enable ''
            allow_empty_token = false
          '')
          (mkIf (cfg.jwt.enable && cfg.jwt.verifyDomain) ''
            enable_domain_verification = true
          '')
          (mkIf (cfg.jwt.enable && cfg.jwt.issuer != null) ''
            asap_accepted_issuers = { "${cfg.jwt.issuer}" }
          '')
          (mkIf (cfg.jwt.enable && cfg.jwt.audience != null) ''
            asap_accepted_audiences = { "${cfg.jwt.audience}" }
          '')
        ];
        ssl = {
          cert = "/var/lib/jitsi-meet/jitsi-meet.crt";
          key = "/var/lib/jitsi-meet/jitsi-meet.key";
        };
      };
      virtualHosts."auth.${cfg.hostName}" = {
        enabled = true;
        domain = "auth.${cfg.hostName}";
        extraConfig = ''
          authentication = "internal_plain"
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
      '';
      serviceConfig = {
        EnvironmentFile = [ "/var/lib/jitsi-meet/secrets-env" ];
        SupplementaryGroups = [ "jitsi-meet" ];
      };
      reloadIfChanged = true;
    };

    users.groups.jitsi-meet = {};
    systemd.tmpfiles.rules = [
      "d '/var/lib/jitsi-meet' 0750 root jitsi-meet - -"
    ];

    systemd.services.jitsi-meet-init-secrets = {
      wantedBy = [ "multi-user.target" ];
      before = [ "jicofo.service" "jitsi-videobridge2.service" ] ++ (optional cfg.prosody.enable "prosody.service");
      serviceConfig = {
        Type = "oneshot";
      };

      script = let
        jwtSecretFile = if cfg.jwt.secretFile == null then "jwt-secret" else "${cfg.jwt.secretFile}";
        secrets = [ "jicofo-component-secret" "jicofo-user-secret" "jibri-auth-secret" "jibri-recorder-secret" ]
          ++ (optional (cfg.videobridge.passwordFile == null) "videobridge-secret")
          ++ (optional (cfg.jwt.enable && cfg.jwt.secretFile == null) "jwt-secret");
      in
      ''
        cd /var/lib/jitsi-meet
        ${concatMapStringsSep "\n" (s: ''
          if [ ! -f ${s} ]; then
            tr -dc a-zA-Z0-9 </dev/urandom | head -c 64 > ${s}
            chown root:jitsi-meet ${s}
            chmod 640 ${s}
          fi
        '') secrets}

        # for easy access in prosody
        echo "JICOFO_COMPONENT_SECRET=$(cat jicofo-component-secret)" > secrets-env
        if [ -f "${jwtSecretFile}" ]; then
          echo "JITSI_JWT_SECRET=$(cat "${jwtSecretFile}")" >> secrets-env
        fi

        chown root:jitsi-meet secrets-env
        chmod 640 secrets-env
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
          chmod 640 /var/lib/jitsi-meet/jitsi-meet.{crt,key}
          chown root:jitsi-meet /var/lib/jitsi-meet/jitsi-meet.{crt,key}
        fi
      '';
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
          proxyPass = "http://127.0.0.1:5280/xmpp-websocket$is_args$args";
          proxyWebsockets = true;
        };
        locations."=/http-bind" = {
          proxyPass = "http://127.0.0.1:5280/http-bind$is_args$args";
          extraConfig = ''
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $host;
          '';
        };
        locations."=/external_api.js" = mkDefault {
          alias = "${pkgs.jitsi-meet}/libs/external_api.min.js";
        };
        locations."=/config.js" = mkDefault {
          alias = overrideJs "${pkgs.jitsi-meet}/config.js" "config" (recursiveUpdate defaultCfg cfg.config) cfg.extraConfig;
        };
        locations."=/interface_config.js" = mkDefault {
          alias = overrideJs "${pkgs.jitsi-meet}/interface_config.js" "interfaceConfig" cfg.interfaceConfig "";
        };
      };
    };

    services.caddy = mkIf cfg.caddy.enable {
      enable = mkDefault true;
      virtualHosts.${cfg.hostName} = {
        extraConfig =
        let
          templatedJitsiMeet = pkgs.runCommand "templated-jitsi-meet" {} ''
            cp -R ${pkgs.jitsi-meet}/* .
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
        in ''
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

    services.jitsi-videobridge = mkIf cfg.videobridge.enable {
      enable = true;
      xmppConfigs."localhost" = {
        userName = "jvb";
        domain = "auth.${cfg.hostName}";
        passwordFile = "/var/lib/jitsi-meet/videobridge-secret";
        mucJids = "jvbbrewery@internal.${cfg.hostName}";
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
      bridgeMuc = "jvbbrewery@internal.${cfg.hostName}";
      config = mkMerge [
        {
          "org.jitsi.jicofo.ALWAYS_TRUST_MODE_ENABLED" = "true";
        }
        (lib.mkIf (config.services.jibri.enable || cfg.jibri.enable) {
          "org.jitsi.jicofo.jibri.BREWERY" = "JibriBrewery@internal.${cfg.hostName}";
          "org.jitsi.jicofo.jibri.PENDING_TIMEOUT" = "90";
        })
      ];
    };

    services.jibri = mkIf cfg.jibri.enable {
      enable = true;

      xmppEnvironments."jitsi-meet" = {
        xmppServerHosts = [ "localhost" ];
        xmppDomain = cfg.hostName;

        control.muc = {
          domain = "internal.${cfg.hostName}";
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
  };

  meta.doc = ./jitsi-meet.xml;
  meta.maintainers = lib.teams.jitsi.members;
}
