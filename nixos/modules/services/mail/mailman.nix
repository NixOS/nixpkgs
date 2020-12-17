{ config, pkgs, lib, ... }:          # mailman.nix

with lib;

let

  cfg = config.services.mailman;

  pythonEnv = pkgs.python3.withPackages (ps:
    [ps.mailman ps.mailman-web]
    ++ lib.optional cfg.hyperkitty.enable ps.mailman-hyperkitty
    ++ cfg.extraPythonPackages);

  # This deliberately doesn't use recursiveUpdate so users can
  # override the defaults.
  webSettings = {
    DEFAULT_FROM_EMAIL = cfg.siteOwner;
    SERVER_EMAIL = cfg.siteOwner;
    ALLOWED_HOSTS = [ "localhost" "127.0.0.1" ] ++ cfg.webHosts;
    COMPRESS_OFFLINE = true;
    STATIC_ROOT = "/var/lib/mailman-web-static";
    MEDIA_ROOT = "/var/lib/mailman-web/media";
    LOGGING = {
      version = 1;
      disable_existing_loggers = true;
      handlers.console.class = "logging.StreamHandler";
      loggers.django = {
        handlers = [ "console" ];
        level = "INFO";
      };
    };
    HAYSTACK_CONNECTIONS.default = {
      ENGINE = "haystack.backends.whoosh_backend.WhooshEngine";
      PATH = "/var/lib/mailman-web/fulltext-index";
    };
  } // cfg.webSettings;

  webSettingsJSON = pkgs.writeText "settings.json" (builtins.toJSON webSettings);

  # TODO: Should this be RFC42-ised so that users can set additional options without modifying the module?
  postfixMtaConfig = pkgs.writeText "mailman-postfix.cfg" ''
    [postfix]
    postmap_command: ${pkgs.postfix}/bin/postmap
    transport_file_type: hash
  '';

  mailmanCfg = lib.generators.toINI {} cfg.settings;

  mailmanHyperkittyCfg = pkgs.writeText "mailman-hyperkitty.cfg" ''
    [general]
    # This is your HyperKitty installation, preferably on the localhost. This
    # address will be used by Mailman to forward incoming emails to HyperKitty
    # for archiving. It does not need to be publicly available, in fact it's
    # better if it is not.
    base_url: ${cfg.hyperkitty.baseUrl}

    # Shared API key, must be the identical to the value in HyperKitty's
    # settings.
    api_key: @API_KEY@
  '';

in {

  ###### interface

  imports = [
    (mkRenamedOptionModule [ "services" "mailman" "hyperkittyBaseUrl" ]
      [ "services" "mailman" "hyperkitty" "baseUrl" ])

    (mkRemovedOptionModule [ "services" "mailman" "hyperkittyApiKey" ] ''
      The Hyperkitty API key is now generated on first run, and not
      stored in the world-readable Nix store.  To continue using
      Hyperkitty, you must set services.mailman.hyperkitty.enable = true.
    '')
  ];

  options = {

    services.mailman = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable Mailman on this host. Requires an active MTA on the host (e.g. Postfix).";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.mailman;
        defaultText = "pkgs.mailman";
        example = literalExample "pkgs.mailman.override { archivers = []; }";
        description = "Mailman package to use";
      };

      enablePostfix = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = ''
          Enable Postfix integration. Requires an active Postfix installation.

          If you want to use another MTA, set this option to false and configure
          settings in services.mailman.settings.mta.

          Refer to the Mailman manual for more info.
        '';
      };

      siteOwner = mkOption {
        type = types.str;
        example = "postmaster@example.org";
        description = ''
          Certain messages that must be delivered to a human, but which can't
          be delivered to a list owner (e.g. a bounce from a list owner), will
          be sent to this address. It should point to a human.
        '';
      };

      webHosts = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          The list of hostnames and/or IP addresses from which the Mailman Web
          UI will accept requests. By default, "localhost" and "127.0.0.1" are
          enabled. All additional names under which your web server accepts
          requests for the UI must be listed here or incoming requests will be
          rejected.
        '';
      };

      webUser = mkOption {
        type = types.str;
        default = "mailman-web";
        description = ''
          User to run mailman-web as
        '';
      };

      webSettings = mkOption {
        type = types.attrs;
        default = {};
        description = ''
          Overrides for the default mailman-web Django settings.
        '';
      };

      serve = {
        enable = mkEnableOption "Automatic nginx and uwsgi setup for mailman-web";
      };

      extraPythonPackages = mkOption {
        description = "Packages to add to the python environment used by mailman and mailman-web";
        type = types.listOf types.package;
        default = [];
      };

      settings = mkOption {
        description = "Settings for mailman.cfg";
        type = types.attrsOf (types.attrsOf types.str);
        default = {};
      };

      hyperkitty = {
        enable = mkEnableOption "the Hyperkitty archiver for Mailman";

        baseUrl = mkOption {
          type = types.str;
          default = "http://localhost/hyperkitty/";
          description = ''
            Where can Mailman connect to Hyperkitty's internal API, preferably on
            localhost?
          '';
        };
      };

    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    services.mailman.settings = {
      mailman.site_owner = lib.mkDefault cfg.siteOwner;
      mailman.layout = "fhs";

      "paths.fhs" = {
        bin_dir = "${pkgs.python3Packages.mailman}/bin";
        var_dir = "/var/lib/mailman";
        queue_dir = "$var_dir/queue";
        template_dir = "$var_dir/templates";
        log_dir = "/var/log/mailman";
        lock_dir = "$var_dir/lock";
        etc_dir = "/etc";
        ext_dir = "$etc_dir/mailman.d";
        pid_file = "/run/mailman/master.pid";
      };

      mta.configuration = lib.mkDefault (if cfg.enablePostfix then "${postfixMtaConfig}" else throw "When Mailman Postfix integration is disabled, set `services.mailman.settings.mta.configuration` to the path of the config file required to integrate with your MTA.");

      "archiver.hyperkitty" = lib.mkIf cfg.hyperkitty.enable {
        class = "mailman_hyperkitty.Archiver";
        enable = "yes";
        configuration = "/var/lib/mailman/mailman-hyperkitty.cfg";
      };
    } // (let
      loggerNames = ["root" "archiver" "bounce" "config" "database" "debug" "error" "fromusenet" "http" "locks" "mischief" "plugins" "runner" "smtp"];
      loggerSectionNames = map (n: "logging.${n}") loggerNames;
      in lib.genAttrs loggerSectionNames(name: { handler = "stderr"; })
    );

    assertions = let
      inherit (config.services) postfix;

      requirePostfixHash = optionPath: dataFile:
        with lib;
        let
          expected = "hash:/var/lib/mailman/data/${dataFile}";
          value = attrByPath optionPath [] postfix;
        in
          { assertion = postfix.enable -> isList value && elem expected value;
            message = ''
              services.postfix.${concatStringsSep "." optionPath} must contain
              "${expected}".
              See <https://mailman.readthedocs.io/en/latest/src/mailman/docs/mta.html>.
            '';
          };
    in (lib.optionals cfg.enablePostfix [
      { assertion = postfix.enable;
        message = ''
          Mailman's default NixOS configuration requires Postfix to be enabled.

          If you want to use another MTA, set services.mailman.enablePostfix
          to false and configure settings in services.mailman.settings.mta.

          Refer to <https://mailman.readthedocs.io/en/latest/src/mailman/docs/mta.html>
          for more info.
        '';
      }
      (requirePostfixHash [ "relayDomains" ] "postfix_domains")
      (requirePostfixHash [ "config" "transport_maps" ] "postfix_lmtp")
      (requirePostfixHash [ "config" "local_recipient_maps" ] "postfix_lmtp")
    ]);

    users.users.mailman = {
      description = "GNU Mailman";
      isSystemUser = true;
      group = "mailman";
    };
    users.users.mailman-web = lib.mkIf (cfg.webUser == "mailman-web") {
      description = "GNU Mailman web interface";
      isSystemUser = true;
      group = "mailman";
    };
    users.groups.mailman = {};

    environment.etc."mailman.cfg".text = mailmanCfg;

    environment.etc."mailman3/settings.py".text = ''
      import os

      # Required by mailman_web.settings, but will be overridden when
      # settings_local.json is loaded.
      os.environ["SECRET_KEY"] = ""

      from mailman_web.settings import *

      import json

      with open('${webSettingsJSON}') as f:
          globals().update(json.load(f))

      with open('/var/lib/mailman-web/settings_local.json') as f:
          globals().update(json.load(f))
    '';

    services.nginx = mkIf cfg.serve.enable {
      enable = mkDefault true;
      virtualHosts."${lib.head cfg.webHosts}" = {
        serverAliases = cfg.webHosts;
        locations = {
          "/".extraConfig = "uwsgi_pass unix:/run/mailman-web.socket;";
          "/static/".alias = webSettings.STATIC_ROOT + "/";
        };
      };
    };

    environment.systemPackages = [ (pkgs.buildEnv {
      name = "mailman-tools";
      # We don't want to pollute the system PATH with a python
      # interpreter etc. so let's pick only the stuff we actually
      # want from pythonEnv
      pathsToLink = ["/bin"];
      paths = [pythonEnv];
      postBuild = ''
        find $out/bin/ -mindepth 1 -not -name "mailman*" -delete
      '';
    }) ];

    services.postfix = lib.mkIf cfg.enablePostfix {
      recipientDelimiter = "+";         # bake recipient addresses in mail envelopes via VERP
      config = {
        owner_request_special = "no";   # Mailman handles -owner addresses on its own
      };
    };

    systemd.sockets.mailman-uwsgi = lib.mkIf cfg.serve.enable {
      wantedBy = ["sockets.target"];
      before = ["nginx.service"];
      socketConfig.ListenStream = "/run/mailman-web.socket";
    };
    systemd.services = {
      mailman = {
        description = "GNU Mailman Master Process";
        after = [ "network.target" ];
        restartTriggers = [ config.environment.etc."mailman.cfg".source ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${pythonEnv}/bin/mailman start";
          ExecStop = "${pythonEnv}/bin/mailman stop";
          User = "mailman";
          Group = "mailman";
          Type = "forking";
          RuntimeDirectory = "mailman";
          LogsDirectory = "mailman";
          PIDFile = "/run/mailman/master.pid";
        };
      };

      mailman-settings = {
        description = "Generate settings files (including secrets) for Mailman";
        before = [ "mailman.service" "mailman-web-setup.service" "mailman-uwsgi.service" "hyperkitty.service" ];
        requiredBy = [ "mailman.service" "mailman-web-setup.service" "mailman-uwsgi.service" "hyperkitty.service" ];
        path = with pkgs; [ jq ];
        script = ''
          mailmanDir=/var/lib/mailman
          mailmanWebDir=/var/lib/mailman-web

          mailmanCfg=$mailmanDir/mailman-hyperkitty.cfg
          mailmanWebCfg=$mailmanWebDir/settings_local.json

          install -m 0775 -o mailman -g mailman -d /var/lib/mailman-web-static
          install -m 0770 -o mailman -g mailman -d $mailmanDir
          install -m 0770 -o ${cfg.webUser} -g mailman -d $mailmanWebDir

          if [ ! -e $mailmanWebCfg ]; then
              hyperkittyApiKey=$(tr -dc A-Za-z0-9 < /dev/urandom | head -c 64)
              secretKey=$(tr -dc A-Za-z0-9 < /dev/urandom | head -c 64)

              mailmanWebCfgTmp=$(mktemp)
              jq -n '.MAILMAN_ARCHIVER_KEY=$archiver_key | .SECRET_KEY=$secret_key' \
                  --arg archiver_key "$hyperkittyApiKey" \
                  --arg secret_key "$secretKey" \
                  >"$mailmanWebCfgTmp"
              chown root:mailman "$mailmanWebCfgTmp"
              chmod 440 "$mailmanWebCfgTmp"
              mv -n "$mailmanWebCfgTmp" "$mailmanWebCfg"
          fi

          hyperkittyApiKey="$(jq -r .MAILMAN_ARCHIVER_KEY "$mailmanWebCfg")"
          mailmanCfgTmp=$(mktemp)
          sed "s/@API_KEY@/$hyperkittyApiKey/g" ${mailmanHyperkittyCfg} >"$mailmanCfgTmp"
          chown mailman:mailman "$mailmanCfgTmp"
          mv "$mailmanCfgTmp" "$mailmanCfg"
        '';
      };

      mailman-web-setup = {
        description = "Prepare mailman-web files and database";
        before = [ "uwsgi.service" "mailman-uwsgi.service" ];
        requiredBy = [ "mailman-uwsgi.service" ];
        restartTriggers = [ config.environment.etc."mailman3/settings.py".source ];
        script = ''
          [[ -e "${webSettings.STATIC_ROOT}" ]] && find "${webSettings.STATIC_ROOT}/" -mindepth 1 -delete
          ${pythonEnv}/bin/mailman-web migrate
          ${pythonEnv}/bin/mailman-web collectstatic
          ${pythonEnv}/bin/mailman-web compress
        '';
        serviceConfig = {
          User = cfg.webUser;
          Group = "mailman";
          Type = "oneshot";
          WorkingDirectory = "/var/lib/mailman-web";
        };
      };

      mailman-uwsgi = mkIf cfg.serve.enable (let
        uwsgiConfig.uwsgi = {
          type = "normal";
          plugins = ["python3"];
          home = pythonEnv;
          module = "mailman_web.wsgi";
        };
        uwsgiConfigFile = pkgs.writeText "uwsgi-mailman.json" (builtins.toJSON uwsgiConfig);
      in {
        wantedBy = ["multi-user.target"];
        requires = ["mailman-uwsgi.socket" "mailman-web-setup.service"];
        restartTriggers = [ config.environment.etc."mailman3/settings.py".source ];
        serviceConfig = {
          # Since the mailman-web settings.py obstinately creates a logs
          # dir in the cwd, change to the (writable) runtime directory before
          # starting uwsgi.
          ExecStart = "${pkgs.coreutils}/bin/env -C $RUNTIME_DIRECTORY ${pkgs.uwsgi.override { plugins = ["python3"]; }}/bin/uwsgi --json ${uwsgiConfigFile}";
          User = cfg.webUser;
          Group = "mailman";
          RuntimeDirectory = "mailman-uwsgi";
        };
      });

      mailman-daily = {
        description = "Trigger daily Mailman events";
        startAt = "daily";
        restartTriggers = [ config.environment.etc."mailman.cfg".source ];
        serviceConfig = {
          ExecStart = "${pythonEnv}/bin/mailman digests --send";
          User = "mailman";
          Group = "mailman";
        };
      };

      hyperkitty = lib.mkIf cfg.hyperkitty.enable {
        description = "GNU Hyperkitty QCluster Process";
        after = [ "network.target" ];
        restartTriggers = [ config.environment.etc."mailman3/settings.py".source ];
        wantedBy = [ "mailman.service" "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${pythonEnv}/bin/mailman-web qcluster";
          User = cfg.webUser;
          Group = "mailman";
          WorkingDirectory = "/var/lib/mailman-web";
        };
      };
    } // flip lib.mapAttrs' {
      "minutely" = "minutely";
      "quarter_hourly" = "*:00/15";
      "hourly" = "hourly";
      "daily" = "daily";
      "weekly" = "weekly";
      "yearly" = "yearly";
    } (name: startAt:
      lib.nameValuePair "hyperkitty-${name}" (lib.mkIf cfg.hyperkitty.enable {
        description = "Trigger ${name} Hyperkitty events";
        inherit startAt;
        restartTriggers = [ config.environment.etc."mailman3/settings.py".source ];
        serviceConfig = {
          ExecStart = "${pythonEnv}/bin/mailman-web runjobs ${name}";
          User = cfg.webUser;
          Group = "mailman";
          WorkingDirectory = "/var/lib/mailman-web";
        };
      }));
  };

  meta = {
    maintainers = with lib.maintainers; [ lheckemann ];
    doc = ./mailman.xml;
  };

}
