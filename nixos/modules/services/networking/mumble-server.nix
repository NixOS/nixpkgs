{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.murmur;
  forking = cfg.logFile != null;
  configFile = pkgs.writeText "murmurd.ini" ''
    database=${cfg.stateDir}/murmur.sqlite
    dbDriver=QSQLITE

    autobanAttempts=${toString cfg.autobanAttempts}
    autobanTimeframe=${toString cfg.autobanTimeframe}
    autobanTime=${toString cfg.autobanTime}

    logfile=${lib.optionalString (cfg.logFile != null) cfg.logFile}
    ${lib.optionalString forking "pidfile=/run/murmur/murmurd.pid"}

    welcometext="${cfg.welcometext}"
    port=${toString cfg.port}

    ${lib.optionalString (cfg.hostName != "") "host=${cfg.hostName}"}
    ${lib.optionalString (cfg.password != "") "serverpassword=${cfg.password}"}

    bandwidth=${toString cfg.bandwidth}
    users=${toString cfg.users}

    textmessagelength=${toString cfg.textMsgLength}
    imagemessagelength=${toString cfg.imgMsgLength}
    allowhtml=${lib.boolToString cfg.allowHtml}
    logdays=${toString cfg.logDays}
    bonjour=${lib.boolToString cfg.bonjour}
    sendversion=${lib.boolToString cfg.sendVersion}

    ${lib.optionalString (cfg.registerName != "") "registerName=${cfg.registerName}"}
    ${lib.optionalString (cfg.registerPassword != "") "registerPassword=${cfg.registerPassword}"}
    ${lib.optionalString (cfg.registerUrl != "") "registerUrl=${cfg.registerUrl}"}
    ${lib.optionalString (cfg.registerHostname != "") "registerHostname=${cfg.registerHostname}"}

    certrequired=${lib.boolToString cfg.clientCertRequired}
    ${lib.optionalString (cfg.sslCert != "") "sslCert=${cfg.sslCert}"}
    ${lib.optionalString (cfg.sslKey != "") "sslKey=${cfg.sslKey}"}
    ${lib.optionalString (cfg.sslCa != "") "sslCA=${cfg.sslCa}"}

    ${lib.optionalString (cfg.dbus != null) "dbus=${cfg.dbus}"}

    ${cfg.extraConfig}
  '';
in
{
  options = {
    services.murmur = {
      enable = lib.mkEnableOption "Mumble server";

      openFirewall = lib.mkEnableOption "opening ports in the firewall for the Mumble server";

      user = lib.mkOption {
        type = lib.types.str;
        default = "murmur";
        description = ''
          The name of an existing user to use to run the service.
          If not specified, the default user will be created.
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "murmur";
        description = ''
          The name of an existing group to use to run the service.
          If not specified, the default group will be created.
        '';
      };

      stateDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/murmur";
        description = ''
          Directory to store data for the server.
        '';
      };

      autobanAttempts = lib.mkOption {
        type = lib.types.int;
        default = 10;
        description = ''
          Number of attempts a client is allowed to make in
          `autobanTimeframe` seconds, before being
          banned for `autobanTime`.
        '';
      };

      autobanTimeframe = lib.mkOption {
        type = lib.types.int;
        default = 120;
        description = ''
          Timeframe in which a client can connect without being banned
          for repeated attempts (in seconds).
        '';
      };

      autobanTime = lib.mkOption {
        type = lib.types.int;
        default = 300;
        description = "The amount of time an IP ban lasts (in seconds).";
      };

      logFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/var/log/murmur/murmurd.log";
        description = "Path to the log file for Murmur daemon. Empty means log to journald.";
      };

      welcometext = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Welcome message for connected clients.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 64738;
        description = "Ports to bind to (UDP and TCP).";
      };

      hostName = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Host to bind to. Defaults binding on all addresses.";
      };

      package = lib.mkPackageOption pkgs "mumble-server" { };

      password = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Required password to join server, if specified.";
      };

      bandwidth = lib.mkOption {
        type = lib.types.int;
        default = 72000;
        description = ''
          Maximum bandwidth (in bits per second) that clients may send
          speech at.
        '';
      };

      users = lib.mkOption {
        type = lib.types.int;
        default = 100;
        description = "Maximum number of concurrent clients allowed.";
      };

      textMsgLength = lib.mkOption {
        type = lib.types.int;
        default = 5000;
        description = "Max length of text messages. Set 0 for no limit.";
      };

      imgMsgLength = lib.mkOption {
        type = lib.types.int;
        default = 131072;
        description = "Max length of image messages. Set 0 for no limit.";
      };

      allowHtml = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Allow HTML in client messages, comments, and channel
          descriptions.
        '';
      };

      logDays = lib.mkOption {
        type = lib.types.int;
        default = 31;
        description = ''
          How long to store RPC logs for in the database. Set 0 to
          keep logs forever, or -1 to disable DB logging.
        '';
      };

      bonjour = lib.mkEnableOption "Bonjour auto-discovery, which allows clients over your LAN to automatically discover Mumble servers";

      sendVersion = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Send Murmur version in UDP response.";
      };

      registerName = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Public server registration name, and also the name of the
          Root channel. Even if you don't publicly register your
          server, you probably still want to set this.
        '';
      };

      registerPassword = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Public server registry password, used authenticate your
          server to the registry to prevent impersonation; required for
          subsequent registry updates.
        '';
      };

      registerUrl = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "URL website for your server.";
      };

      registerHostname = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          DNS hostname where your server can be reached. This is only
          needed if you want your server to be accessed by its
          hostname and not IP - but the name *must* resolve on the
          internet properly.
        '';
      };

      clientCertRequired = lib.mkEnableOption "requiring clients to authenticate via certificates";

      sslCert = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Path to your SSL certificate.";
      };

      sslKey = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Path to your SSL key.";
      };

      sslCa = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Path to your SSL CA certificate.";
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Extra configuration to put into murmur.ini.";
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = lib.literalExpression ''"''${config.services.murmur.stateDir}/murmurd.env"'';
        description = ''
          Environment file as defined in {manpage}`systemd.exec(5)`.

          Secrets may be passed to the service without adding them to the world-readable
          Nix store, by specifying placeholder variables as the option value in Nix and
          setting these variables accordingly in the environment file.

          ```
            # snippet of murmur-related config
            services.murmur.password = "$MURMURD_PASSWORD";
          ```

          ```
            # content of the environment file
            MURMURD_PASSWORD=verysecretpassword
          ```

          Note that this file needs to be available on the host on which
          `murmur` is running.
        '';
      };

      dbus = lib.mkOption {
        type = lib.types.enum [
          null
          "session"
          "system"
        ];
        default = null;
        description = "Enable D-Bus remote control. Set to the bus you want Murmur to connect to.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.murmur = lib.mkIf (cfg.user == "murmur") {
      description = "Murmur Service user";
      home = cfg.stateDir;
      createHome = true;
      uid = config.ids.uids.murmur;
      group = cfg.group;
    };
    users.groups.murmur = lib.mkIf (cfg.group == "murmur") {
      gid = config.ids.gids.murmur;
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
      allowedUDPPorts = [ cfg.port ];
    };

    systemd.services.murmur = {
      description = "Murmur Chat Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      preStart = ''
        ${pkgs.envsubst}/bin/envsubst \
          -o /run/murmur/murmurd.ini \
          -i ${configFile}
      '';

      serviceConfig = {
        # murmurd doesn't fork when logging to the console.
        Type = if forking then "forking" else "simple";
        PIDFile = lib.mkIf forking "/run/murmur/murmurd.pid";
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
        ExecStart = "${cfg.package}/bin/mumble-server -ini /run/murmur/murmurd.ini";
        Restart = "always";
        RuntimeDirectory = "murmur";
        RuntimeDirectoryMode = "0700";
        User = cfg.user;
        Group = cfg.group;

        # service hardening
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "full";
        RestrictAddressFamilies = "~AF_PACKET AF_NETLINK";
        RestrictNamespaces = true;
        RestrictSUIDSGID = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = "@system-service";
        UMask = 27;
      };
    };

    # currently not included in upstream package, addition requested at
    # https://github.com/mumble-voip/mumble/issues/6078
    services.dbus.packages = lib.mkIf (cfg.dbus == "system") [
      (pkgs.writeTextFile {
        name = "murmur-dbus-policy";
        text = ''
          <!DOCTYPE busconfig PUBLIC
            "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
            "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
          <busconfig>
            <policy user="${cfg.user}">
              <allow own="net.sourceforge.mumble.murmur"/>
            </policy>

            <policy context="default">
              <allow send_destination="net.sourceforge.mumble.murmur"/>
              <allow receive_sender="net.sourceforge.mumble.murmur"/>
            </policy>
          </busconfig>
        '';
        destination = "/share/dbus-1/system.d/murmur.conf";
      })
    ];

    security.apparmor.policies."bin.mumble-server".profile =
      ''
        include <tunables/global>

        ${cfg.package}/bin/{mumble-server,.mumble-server-wrapped} {
          include <abstractions/base>
          include <abstractions/nameservice>
          include <abstractions/ssl_certs>
          include "${pkgs.apparmorRulesFromClosure { name = "mumble-server"; } cfg.package}"
          pix ${cfg.package}/bin/.mumble-server-wrapped,

          r ${config.environment.etc."os-release".source},
          r ${config.environment.etc."lsb-release".source},
          owner rwk ${cfg.stateDir}/murmur.sqlite,
          owner rw ${cfg.stateDir}/murmur.sqlite-journal,
          owner r ${cfg.stateDir}/,
          r /run/murmur/murmurd.pid,
          r /run/murmur/murmurd.ini,
          r ${configFile},
      ''
      + lib.optionalString (cfg.logFile != null) ''
        rw ${cfg.logFile},
      ''
      + lib.optionalString (cfg.sslCert != "") ''
        r ${cfg.sslCert},
      ''
      + lib.optionalString (cfg.sslKey != "") ''
        r ${cfg.sslKey},
      ''
      + lib.optionalString (cfg.sslCa != "") ''
        r ${cfg.sslCa},
      ''
      + lib.optionalString (cfg.dbus != null) ''
        dbus bus=${cfg.dbus}
      ''
      + ''
        }
      '';
  };

  meta.maintainers = with lib.maintainers; [ felixsinger ];
}
