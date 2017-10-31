{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.murmur;
  configFile = pkgs.writeText "murmurd.ini" ''
    database=/var/lib/murmur/murmur.sqlite
    dbDriver=QSQLITE

    autobanAttempts=${toString cfg.autobanAttempts}
    autobanTimeframe=${toString cfg.autobanTimeframe}
    autobanTime=${toString cfg.autobanTime}

    logfile=/var/log/murmur/murmurd.log
    pidfile=${cfg.pidfile}

    welcometext="${cfg.welcometext}"
    port=${toString cfg.port}

    ${if cfg.hostName == "" then "" else "host="+cfg.hostName}
    ${if cfg.password == "" then "" else "serverpassword="+cfg.password}

    bandwidth=${toString cfg.bandwidth}
    users=${toString cfg.users}

    textmessagelength=${toString cfg.textMsgLength}
    imagemessagelength=${toString cfg.imgMsgLength}
    allowhtml=${boolToString cfg.allowHtml}
    logdays=${toString cfg.logDays}
    bonjour=${boolToString cfg.bonjour}
    sendversion=${boolToString cfg.sendVersion}

    ${if cfg.registerName     == "" then "" else "registerName="+cfg.registerName}
    ${if cfg.registerPassword == "" then "" else "registerPassword="+cfg.registerPassword}
    ${if cfg.registerUrl      == "" then "" else "registerUrl="+cfg.registerUrl}
    ${if cfg.registerHostname == "" then "" else "registerHostname="+cfg.registerHostname}

    certrequired=${boolToString cfg.clientCertRequired}
    ${if cfg.sslCert == "" then "" else "sslCert="+cfg.sslCert}
    ${if cfg.sslKey  == "" then "" else "sslKey="+cfg.sslKey}
    ${if cfg.sslCa   == "" then "" else "sslCA="+cfg.sslCa}

    ${cfg.extraConfig}
  '';
in
{
  options = {
    services.murmur = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "If enabled, start the Murmur Service.";
      };

      autobanAttempts = mkOption {
        type = types.int;
        default = 10;
        description = ''
          Number of attempts a client is allowed to make in
          <literal>autobanTimeframe</literal> seconds, before being
          banned for <literal>autobanTime</literal>.
        '';
      };

      autobanTimeframe = mkOption {
        type = types.int;
        default = 120;
        description = ''
          Timeframe in which a client can connect without being banned
          for repeated attempts (in seconds).
        '';
      };

      autobanTime = mkOption {
        type = types.int;
        default = 300;
        description = "The amount of time an IP ban lasts (in seconds).";
      };

      pidfile = mkOption {
        type = types.path;
        default = "/tmp/murmurd.pid";
        description = "Path to PID file for Murmur daemon.";
      };

      welcometext = mkOption {
        type = types.str;
        default = "";
        description = "Welcome message for connected clients.";
      };

      port = mkOption {
        type = types.int;
        default = 64738;
        description = "Ports to bind to (UDP and TCP).";
      };

      hostName = mkOption {
        type = types.str;
        default = "";
        description = "Host to bind to. Defaults binding on all addresses.";
      };

      password = mkOption {
        type = types.str;
        default = "";
        description = "Required password to join server, if specified.";
      };

      bandwidth = mkOption {
        type = types.int;
        default = 72000;
        description = ''
          Maximum bandwidth (in bits per second) that clients may send
          speech at.
        '';
      };

      users = mkOption {
        type = types.int;
        default = 100;
        description = "Maximum number of concurrent clients allowed.";
      };

      textMsgLength = mkOption {
        type = types.int;
        default = 5000;
        description = "Max length of text messages. Set 0 for no limit.";
      };

      imgMsgLength = mkOption {
        type = types.int;
        default = 131072;
        description = "Max length of image messages. Set 0 for no limit.";
      };

      allowHtml = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Allow HTML in client messages, comments, and channel
          descriptions.
        '';
      };

      logDays = mkOption {
        type = types.int;
        default = 31;
        description = ''
          How long to store RPC logs for in the database. Set 0 to
          keep logs forever, or -1 to disable DB logging.
        '';
      };

      bonjour = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable Bonjour auto-discovery, which allows clients over
          your LAN to automatically discover Murmur servers.
        '';
      };

      sendVersion = mkOption {
        type = types.bool;
        default = true;
        description = "Send Murmur version in UDP response.";
      };

      registerName = mkOption {
        type = types.str;
        default = "";
        description = ''
          Public server registration name, and also the name of the
          Root channel. Even if you don't publicly register your
          server, you probably still want to set this.
        '';
      };

      registerPassword = mkOption {
        type = types.str;
        default = "";
        description = ''
          Public server registry password, used authenticate your
          server to the registry to prevent impersonation; required for
          subsequent registry updates.
        '';
      };

      registerUrl = mkOption {
        type = types.str;
        default = "";
        description = "URL website for your server.";
      };

      registerHostname = mkOption {
        type = types.str;
        default = "";
        description = ''
          DNS hostname where your server can be reached. This is only
          needed if you want your server to be accessed by its
          hostname and not IP - but the name *must* resolve on the
          internet properly.
        '';
      };

      clientCertRequired = mkOption {
        type = types.bool;
        default = false;
        description = "Require clients to authenticate via certificates.";
      };

      sslCert = mkOption {
        type = types.str;
        default = "";
        description = "Path to your SSL certificate.";
      };

      sslKey = mkOption {
        type = types.str;
        default = "";
        description = "Path to your SSL key.";
      };

      sslCa = mkOption {
        type = types.str;
        default = "";
        description = "Path to your SSL CA certificate.";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Extra configuration to put into mumur.ini.";
      };
    };
  };

  config = mkIf cfg.enable {
    users.extraUsers.murmur = {
      description     = "Murmur Service user";
      home            = "/var/lib/murmur";
      createHome      = true;
      uid             = config.ids.uids.murmur;
    };

    systemd.services.murmur = {
      description = "Murmur Chat Service";
      wantedBy    = [ "multi-user.target" ];
      after       = [ "network.target "];

      serviceConfig = {
        Type      = "forking";
        PIDFile   = cfg.pidfile;
        Restart   = "always";
        User      = "murmur";
        ExecStart = "${pkgs.murmur}/bin/murmurd -ini ${configFile}";
        PermissionsStartOnly = true;
      };

      preStart = ''
        mkdir -p /var/log/murmur
        chown -R murmur /var/log/murmur
      '';
    };
  };
}
