{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.murmur;
  forking = cfg.logFile != null;
  configFile = pkgs.writeText "murmurd.ini" ''
    database=/var/lib/murmur/murmur.sqlite
    dbDriver=QSQLITE

    autobanAttempts=${toString cfg.autobanAttempts}
    autobanTimeframe=${toString cfg.autobanTimeframe}
    autobanTime=${toString cfg.autobanTime}

    logfile=${optionalString (cfg.logFile != null) cfg.logFile}
    ${optionalString forking "pidfile=/run/murmur/murmurd.pid"}

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
  imports = [
    (mkRenamedOptionModule [ "services" "murmur" "welcome" ] [ "services" "murmur" "welcometext" ])
    (mkRemovedOptionModule [ "services" "murmur" "pidfile" ] "Hardcoded to /run/murmur/murmurd.pid now")
  ];

  options = {
    services.murmur = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "If enabled, start the Murmur Mumble server.";
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

      logFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/var/log/murmur/murmurd.log";
        description = "Path to the log file for Murmur daemon. Empty means log to journald.";
      };

      welcometext = mkOption {
        type = types.str;
        default = "";
        description = "Welcome message for connected clients.";
      };

      port = mkOption {
        type = types.port;
        default = 64738;
        description = "Ports to bind to (UDP and TCP).";
      };

      hostName = mkOption {
        type = types.str;
        default = "";
        description = "Host to bind to. Defaults binding on all addresses.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.murmur;
        defaultText = literalExpression "pkgs.murmur";
        description = "Overridable attribute of the murmur package to use.";
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
        description = "Extra configuration to put into murmur.ini.";
      };

      environmentFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/var/lib/murmur/murmurd.env";
        description = ''
          Environment file as defined in <citerefentry>
          <refentrytitle>systemd.exec</refentrytitle><manvolnum>5</manvolnum>
          </citerefentry>.

          Secrets may be passed to the service without adding them to the world-readable
          Nix store, by specifying placeholder variables as the option value in Nix and
          setting these variables accordingly in the environment file.

          <programlisting>
            # snippet of murmur-related config
            services.murmur.password = "$MURMURD_PASSWORD";
          </programlisting>

          <programlisting>
            # content of the environment file
            MURMURD_PASSWORD=verysecretpassword
          </programlisting>

          Note that this file needs to be available on the host on which
          <literal>murmur</literal> is running.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.murmur = {
      description     = "Murmur Service user";
      home            = "/var/lib/murmur";
      createHome      = true;
      uid             = config.ids.uids.murmur;
      group           = "murmur";
    };
    users.groups.murmur = {
      gid             = config.ids.gids.murmur;
    };

    systemd.services.murmur = {
      description = "Murmur Chat Service";
      wantedBy    = [ "multi-user.target" ];
      after       = [ "network-online.target" ];
      preStart    = ''
        ${pkgs.envsubst}/bin/envsubst \
          -o /run/murmur/murmurd.ini \
          -i ${configFile}
      '';

      serviceConfig = {
        # murmurd doesn't fork when logging to the console.
        Type = if forking then "forking" else "simple";
        PIDFile = mkIf forking "/run/murmur/murmurd.pid";
        EnvironmentFile = mkIf (cfg.environmentFile != null) cfg.environmentFile;
        ExecStart = "${cfg.package}/bin/mumble-server -ini /run/murmur/murmurd.ini";
        Restart = "always";
        RuntimeDirectory = "murmur";
        RuntimeDirectoryMode = "0700";
        User = "murmur";
        Group = "murmur";
      };
    };
  };
}
