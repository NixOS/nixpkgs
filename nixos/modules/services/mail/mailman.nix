{ config, pkgs, lib, ... }:          # mailman.nix

with lib;

let

  cfg = config.services.mailman;

  mailmanPyEnv = pkgs.python3.withPackages (ps: with ps; [mailman mailman-hyperkitty]);

  mailmanExe = with pkgs; stdenv.mkDerivation {
    name = "mailman-" + python3Packages.mailman.version;
    buildInputs = [makeWrapper];
    unpackPhase = ":";
    installPhase = ''
      mkdir -p $out/bin
      makeWrapper ${mailmanPyEnv}/bin/mailman $out/bin/mailman \
        --set MAILMAN_CONFIG_FILE /etc/mailman.cfg
   '';
  };

  mailmanWeb = pkgs.python3Packages.mailman-web.override {
    serverEMail = cfg.siteOwner;
    archiverKey = cfg.hyperkittyApiKey;
    allowedHosts = cfg.webHosts;
  };

  mailmanWebPyEnv = pkgs.python3.withPackages (x: with x; [mailman-web]);

  mailmanWebExe = with pkgs; stdenv.mkDerivation {
    inherit (mailmanWeb) name;
    buildInputs = [makeWrapper];
    unpackPhase = ":";
    installPhase = ''
      mkdir -p $out/bin
      makeWrapper ${mailmanWebPyEnv}/bin/django-admin $out/bin/mailman-web \
        --set DJANGO_SETTINGS_MODULE settings
    '';
  };

  mailmanCfg = ''
    [mailman]
    site_owner: ${cfg.siteOwner}
    layout: fhs

    [paths.fhs]
    bin_dir: ${pkgs.python3Packages.mailman}/bin
    var_dir: /var/lib/mailman
    queue_dir: $var_dir/queue
    template_dir: $var_dir/templates
    log_dir: $var_dir/log
    lock_dir: $var_dir/lock
    etc_dir: /etc
    ext_dir: $etc_dir/mailman.d
    pid_file: /run/mailman/master.pid
  '' + optionalString cfg.hyperkitty.enable ''

    [archiver.hyperkitty]
    class: mailman_hyperkitty.Archiver
    enable: yes
    configuration: /var/lib/mailman/mailman-hyperkitty.cfg
  '';

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
        description = "Enable Mailman on this host. Requires an active Postfix installation.";
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

      webRoot = mkOption {
        type = types.path;
        default = "${mailmanWeb}/${pkgs.python3.sitePackages}";
        defaultText = "pkgs.python3Packages.mailman-web";
        description = ''
          The web root for the Hyperkity + Postorius apps provided by Mailman.
          This variable can be set, of course, but it mainly exists so that site
          admins can refer to it in their own hand-written web server
          configuration files.
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
        default = config.services.httpd.user;
        description = ''
          User to run mailman-web as
        '';
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
    in [
      { assertion = postfix.enable;
        message = "Mailman requires Postfix";
      }
      (requirePostfixHash [ "relayDomains" ] "postfix_domains")
      (requirePostfixHash [ "config" "transport_maps" ] "postfix_lmtp")
      (requirePostfixHash [ "config" "local_recipient_maps" ] "postfix_lmtp")
    ];

    users.users.mailman = { description = "GNU Mailman"; isSystemUser = true; };

    environment = {
      systemPackages = [ mailmanExe mailmanWebExe pkgs.sassc ];
      etc."mailman.cfg".text = mailmanCfg;
    };

    services.postfix = {
      recipientDelimiter = "+";         # bake recipient addresses in mail envelopes via VERP
      config = {
        owner_request_special = "no";   # Mailman handles -owner addresses on its own
      };
    };

    systemd.services.mailman = {
      description = "GNU Mailman Master Process";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${mailmanExe}/bin/mailman start";
        ExecStop = "${mailmanExe}/bin/mailman stop";
        User = "mailman";
        Type = "forking";
        RuntimeDirectory = "mailman";
        PIDFile = "/run/mailman/master.pid";
      };
    };

    systemd.services.mailman-secrets = {
      description = "Generate Hyperkitty API key";
      before = [ "mailman.service" "mailman-web.service" "hyperkitty.service" "httpd.service" "uwsgi.service" ];
      requiredBy = [ "mailman.service" "mailman-web.service" "hyperkitty.service" "httpd.service" "uwsgi.service" ];
      script = ''
        mailmanDir=/var/lib/mailman
        mailmanWebDir=/var/lib/mailman-web

        mailmanCfg=$mailmanDir/mailman-hyperkitty.cfg
        hyperkittyCfg=$mailmanWebDir/settings_local.py

        [ -e $mailmanCfg -o -e $hyperkittyCfg ] && exit 0

        install -m 0700 -o mailman -g nogroup -d $mailmanDir
        install -m 0700 -o ${cfg.webUser} -g nogroup -d $mailmanWebDir

        hyperkittyApiKey=$(tr -dc A-Za-z0-9 < /dev/urandom | head -c 64)
        secretKey=$(tr -dc A-Za-z0-9 < /dev/urandom | head -c 64)

        hyperkittyCfgTmp=$(mktemp)
        echo "MAILMAN_ARCHIVER_KEY='$hyperkittyApiKey'" >>"$hyperkittyCfgTmp"
        echo "SECRET_KEY='$secretKey'" >>"$hyperkittyCfgTmp"
        chown ${cfg.webUser} "$hyperkittyCfgTmp"

        mailmanCfgTmp=$(mktemp)
        sed "s/@API_KEY@/$hyperkittyApiKey/g" ${mailmanHyperkittyCfg} >"$mailmanCfgTmp"
        chown mailman "$mailmanCfgTmp"

        mv -n "$hyperkittyCfgTmp" $hyperkittyCfg
        mv -n "$mailmanCfgTmp" $mailmanCfg
      '';
      serviceConfig = {
        Type = "oneshot";
      };
    };

    systemd.services.mailman-web = {
      description = "Init Postorius DB";
      before = [ "httpd.service" "uwsgi.service" ];
      requiredBy = [ "httpd.service" "uwsgi.service" ];
      script = ''
        ${mailmanWebExe}/bin/mailman-web migrate
        rm -rf static
        ${mailmanWebExe}/bin/mailman-web collectstatic
        ${mailmanWebExe}/bin/mailman-web compress
      '';
      serviceConfig = {
        User = cfg.webUser;
        Type = "oneshot";
        WorkingDirectory = "/var/lib/mailman-web";
      };
    };

    systemd.services.mailman-daily = {
      description = "Trigger daily Mailman events";
      startAt = "daily";
      serviceConfig = {
        ExecStart = "${mailmanExe}/bin/mailman digests --send";
        User = "mailman";
      };
    };

    systemd.services.hyperkitty = {
      inherit (cfg.hyperkitty) enable;
      description = "GNU Hyperkitty QCluster Process";
      after = [ "network.target" ];
      wantedBy = [ "mailman.service" "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${mailmanWebExe}/bin/mailman-web qcluster";
        User = cfg.webUser;
        WorkingDirectory = "/var/lib/mailman-web";
      };
    };

    systemd.services.hyperkitty-minutely = {
      inherit (cfg.hyperkitty) enable;
      description = "Trigger minutely Hyperkitty events";
      startAt = "minutely";
      serviceConfig = {
        ExecStart = "${mailmanWebExe}/bin/mailman-web runjobs minutely";
        User = cfg.webUser;
        WorkingDirectory = "/var/lib/mailman-web";
      };
    };

    systemd.services.hyperkitty-quarter-hourly = {
      inherit (cfg.hyperkitty) enable;
      description = "Trigger quarter-hourly Hyperkitty events";
      startAt = "*:00/15";
      serviceConfig = {
        ExecStart = "${mailmanWebExe}/bin/mailman-web runjobs quarter_hourly";
        User = cfg.webUser;
        WorkingDirectory = "/var/lib/mailman-web";
      };
    };

    systemd.services.hyperkitty-hourly = {
      inherit (cfg.hyperkitty) enable;
      description = "Trigger hourly Hyperkitty events";
      startAt = "hourly";
      serviceConfig = {
        ExecStart = "${mailmanWebExe}/bin/mailman-web runjobs hourly";
        User = cfg.webUser;
        WorkingDirectory = "/var/lib/mailman-web";
      };
    };

    systemd.services.hyperkitty-daily = {
      inherit (cfg.hyperkitty) enable;
      description = "Trigger daily Hyperkitty events";
      startAt = "daily";
      serviceConfig = {
        ExecStart = "${mailmanWebExe}/bin/mailman-web runjobs daily";
        User = cfg.webUser;
        WorkingDirectory = "/var/lib/mailman-web";
      };
    };

    systemd.services.hyperkitty-weekly = {
      inherit (cfg.hyperkitty) enable;
      description = "Trigger weekly Hyperkitty events";
      startAt = "weekly";
      serviceConfig = {
        ExecStart = "${mailmanWebExe}/bin/mailman-web runjobs weekly";
        User = cfg.webUser;
        WorkingDirectory = "/var/lib/mailman-web";
      };
    };

    systemd.services.hyperkitty-yearly = {
      inherit (cfg.hyperkitty) enable;
      description = "Trigger yearly Hyperkitty events";
      startAt = "yearly";
      serviceConfig = {
        ExecStart = "${mailmanWebExe}/bin/mailman-web runjobs yearly";
        User = cfg.webUser;
        WorkingDirectory = "/var/lib/mailman-web";
      };
    };

  };

}
