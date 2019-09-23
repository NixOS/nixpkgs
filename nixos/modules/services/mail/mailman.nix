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
  '' + optionalString (cfg.hyperkittyApiKey != null) ''
    [archiver.hyperkitty]
    class: mailman_hyperkitty.Archiver
    enable: yes
    configuration: ${pkgs.writeText "mailman-hyperkitty.cfg" mailmanHyperkittyCfg}
  '';

  mailmanHyperkittyCfg = ''
    [general]
    # This is your HyperKitty installation, preferably on the localhost. This
    # address will be used by Mailman to forward incoming emails to HyperKitty
    # for archiving. It does not need to be publicly available, in fact it's
    # better if it is not.
    base_url: ${cfg.hyperkittyBaseUrl}

    # Shared API key, must be the identical to the value in HyperKitty's
    # settings.
    api_key: ${cfg.hyperkittyApiKey}
  '';

in {

  ###### interface

  options = {

    services.mailman = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable Mailman on this host. Requires an active Postfix installation.";
      };

      siteOwner = mkOption {
        type = types.str;
        default = "postmaster@example.org";
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
          admins can refer to it in their own hand-written httpd configuration files.
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

      hyperkittyBaseUrl = mkOption {
        type = types.str;
        default = "http://localhost/hyperkitty/";
        description = ''
          Where can Mailman connect to Hyperkitty's internal API, preferably on
          localhost?
        '';
      };

      hyperkittyApiKey = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The shared secret used to authenticate Mailman's internal
          communication with Hyperkitty. Must be set to enable support for the
          Hyperkitty archiver. Note that this secret is going to be visible to
          all local users in the Nix store.
        '';
      };

    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    assertions = [
      { assertion = cfg.enable -> config.services.postfix.enable;
        message = "Mailman requires Postfix";
      }
    ];

    users.users.mailman = { description = "GNU Mailman"; isSystemUser = true; };

    environment = {
      systemPackages = [ mailmanExe mailmanWebExe pkgs.sassc ];
      etc."mailman.cfg".text = mailmanCfg;
    };

    services.postfix = {
      relayDomains = [ "hash:/var/lib/mailman/data/postfix_domains" ];
      recipientDelimiter = "+";         # bake recipient addresses in mail envelopes via VERP
      config = {
        transport_maps = [ "hash:/var/lib/mailman/data/postfix_lmtp" ];
        local_recipient_maps = [ "hash:/var/lib/mailman/data/postfix_lmtp" ];
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
        StateDirectory = "mailman";
        StateDirectoryMode = "0700";
        RuntimeDirectory = "mailman";
        PIDFile = "/run/mailman/master.pid";
      };
    };

    systemd.services.mailman-web = {
      description = "Init Postorius DB";
      before = [ "httpd.service" ];
      requiredBy = [ "httpd.service" ];
      script = ''
        ${mailmanWebExe}/bin/mailman-web migrate
        rm -rf static
        ${mailmanWebExe}/bin/mailman-web collectstatic
        ${mailmanWebExe}/bin/mailman-web compress
      '';
      serviceConfig = {
        User = config.services.httpd.user;
        Type = "oneshot";
        StateDirectory = "mailman-web";
        StateDirectoryMode = "0700";
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
      enable = cfg.hyperkittyApiKey != null;
      description = "GNU Hyperkitty QCluster Process";
      after = [ "network.target" ];
      wantedBy = [ "mailman.service" "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${mailmanWebExe}/bin/mailman-web qcluster";
        User = config.services.httpd.user;
        WorkingDirectory = "/var/lib/mailman-web";
      };
    };

    systemd.services.hyperkitty-minutely = {
      enable = cfg.hyperkittyApiKey != null;
      description = "Trigger minutely Hyperkitty events";
      startAt = "minutely";
      serviceConfig = {
        ExecStart = "${mailmanWebExe}/bin/mailman-web runjobs minutely";
        User = config.services.httpd.user;
        WorkingDirectory = "/var/lib/mailman-web";
      };
    };

    systemd.services.hyperkitty-quarter-hourly = {
      enable = cfg.hyperkittyApiKey != null;
      description = "Trigger quarter-hourly Hyperkitty events";
      startAt = "*:00/15";
      serviceConfig = {
        ExecStart = "${mailmanWebExe}/bin/mailman-web runjobs quarter_hourly";
        User = config.services.httpd.user;
        WorkingDirectory = "/var/lib/mailman-web";
      };
    };

    systemd.services.hyperkitty-hourly = {
      enable = cfg.hyperkittyApiKey != null;
      description = "Trigger hourly Hyperkitty events";
      startAt = "hourly";
      serviceConfig = {
        ExecStart = "${mailmanWebExe}/bin/mailman-web runjobs hourly";
        User = config.services.httpd.user;
        WorkingDirectory = "/var/lib/mailman-web";
      };
    };

    systemd.services.hyperkitty-daily = {
      enable = cfg.hyperkittyApiKey != null;
      description = "Trigger daily Hyperkitty events";
      startAt = "daily";
      serviceConfig = {
        ExecStart = "${mailmanWebExe}/bin/mailman-web runjobs daily";
        User = config.services.httpd.user;
        WorkingDirectory = "/var/lib/mailman-web";
      };
    };

    systemd.services.hyperkitty-weekly = {
      enable = cfg.hyperkittyApiKey != null;
      description = "Trigger weekly Hyperkitty events";
      startAt = "weekly";
      serviceConfig = {
        ExecStart = "${mailmanWebExe}/bin/mailman-web runjobs weekly";
        User = config.services.httpd.user;
        WorkingDirectory = "/var/lib/mailman-web";
      };
    };

    systemd.services.hyperkitty-yearly = {
      enable = cfg.hyperkittyApiKey != null;
      description = "Trigger yearly Hyperkitty events";
      startAt = "yearly";
      serviceConfig = {
        ExecStart = "${mailmanWebExe}/bin/mailman-web runjobs yearly";
        User = config.services.httpd.user;
        WorkingDirectory = "/var/lib/mailman-web";
      };
    };

  };

}
