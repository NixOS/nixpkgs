{ config, pkgs, ...}:

with pkgs.lib;

let
  cfg = config.services.nrsysmond;

  configFile = pkgs.writeText "nrsysmond.cfg" ''
    license_key=${cfg.license}
    loglevel=${cfg.loglevel}
    logfile=${toString cfg.logfile}
    ${if cfg.proxy != "" then ("proxy="+cfg.proxy) else ""}
    ssl=${if cfg.ssl then "true" else "false"}
    ssl_ca_bundle=${toString cfg.sslBundle}
    ssl_ca_path=${toString cfg.sslPath}
    pidfile=${toString cfg.pidfile}
    collector_host=${cfg.collectorHost}
    timeout=${toString cfg.timeout}
  '';

in
{
  options = {
    services.nrsysmond = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = '';
          If enabled, start the New Relic system monitor daemon.
        '';
      };

      license = mkOption {
        type = types.str;
        default = "";
        description = ''
          40-character hexadecimal string provided by New Relic,
          required for the monitor to start.
        '';
      };

      loglevel = mkOption {
        type    = types.str;
        default = "info";
        description = ''
          Level of detail you want in the logfile. Valid values are:
            - error
            - warning
            - info
            - verbose
            - debug
            - verbosedebug
        '';
      };

      logfile = mkOption {
        type    = types.path;
        default = "/var/log/newrelic/nrsysmond.log";
        description = ''
          Name of the file where the monitor stores log messages.
        '';
      };

      proxy = mkOption {
        type    = types.str;
        default = "";
        description = ''
          Name and (optional) login credentials of the proxy server to
          use for communication with the New Relic connector.
        '';
      };

      ssl = mkOption {
        type    = types.bool;
        default = true;
        description = ''
          Whether or not to use Secure Sockets Layer (SSL) for
          communication with the New Relic connector.
        '';
      };

      sslBundle = mkOption {
        type    = types.path;
        default = "/etc/ssl/certs/ca-bundle.crt";
        description = ''
          The path of a PEM-encoded Certificate Authority (CA) bundle
          to use for SSL connections.
        '';
      };

      sslPath = mkOption {
        type    = types.path;
        default = "/etc/ssl/certs";
        description = ''
          If your SSL installation does not use CA bundles, but rather
          has a directory with PEM-encoded Certificate Authority
          files, set this option to the name of the directory that
          contains all the CA files.
        '';
      };

      pidfile = mkOption {
        type    = types.path;
        default = "/tmp/nrsysmond.pid";
        description = ''
          Name of a file where the monitoring daemon will store its PID.
        '';
      };

      collectorHost = mkOption {
        type        = types.str;
        default     = "collector.newrelic.com";
        description = ''
          The name of the New Relic collector to connect to.
        '';
      };

      timeout = mkOption {
        type        = types.int;
        default     = 30;
        description = ''
          How long the monitor should wait to contact the collector
          host.
        '';
      };
    };
  };

  config = mkIf config.services.nrsysmond.enable {
    assertions = singleton {
      assertion = stringLength cfg.license == 40;
      message   = "New Relic license key required to be a 40 character hex string";
    };

    users.extraUsers = singleton {
      name        = "newrelic";
      uid         = config.ids.uids.newrelic;
      description = "New Relic daemon user";
      home        = "/var/log/newrelic/";
      createHome  = true;
    };

    systemd.services.nrsysmond = {
      description = "New Relic system monitor";
      wantedBy    = [ "multi-user.target" ];
      serviceConfig = {
        Type      = "forking";
        PIDFile   = cfg.pidfile;
        Restart   = "always";
        User      = "newrelic";
        ExecStart = "${pkgs.newrelic_sysmond}/bin/nrsysmond -c ${configFile}";
      };
    };

    environment.systemPackages = [ pkgs.newrelic_sysmond ];
  };
}
