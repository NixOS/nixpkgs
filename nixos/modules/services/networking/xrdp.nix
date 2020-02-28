{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xrdp;
  sessionData = config.services.xserver.displayManager.sessionData;

  toINI = generators.toINI {};
  mkParams = concatMapStringsSep "\n" (param: "param=${param}");

  xrdpIni = toINI {
    Globals = cfg.globals;
    Logging = cfg.logging;
    Channels = cfg.channels;
    Xorg = cfg.sessions.xorg;
  };

  sesmanIni = (toINI {
    Globals = cfg.sesman.globals;
    Security = cfg.sesman.security;
    Logging = cfg.sesman.logging;
    Sessions = cfg.sesman.sessions;
    Chansrv = cfg.sesman.chansrv;
    SessionVariables = cfg.sesman.sessionVariables;
  }) + ''
    [Xorg]
    ${mkParams cfg.sesman.xorg.params}
  '';

  startwm = pkgs.writeScript "startwm.sh" ''
    #! ${pkgs.bash}/bin/bash

    # get session desktop file
    session_desktop_file=${sessionData.desktops}/share/xsessions/${cfg.sessionName}.desktop

    # parse Exec from desktop file, so we can start session
    session_command=$(grep '^Exec' $session_desktop_file | tail -1 | sed 's/^Exec=//' | sed 's/%.//' | sed 's/^"//g' | sed 's/" *$//g')

    ${cfg.sessionCommand}
  '';

  # keyboard map files
  kmFiles = filterAttrs (k: _: hasPrefix "km-" k) (builtins.readDir "${cfg.package}/etc/xrdp");

  mkAllOptionDefault = mapAttrs (_: mkOptionDefault);

  stringIntOrBool = with types; nullOr (either (either str int) bool);

in {

  ###### interface

  imports = [
    (mkRenamedOptionModule
      ["services" "xrdp" "defaultWindowManager"]
      ["services" "xrdp" "sessionCommand"])
  ];

  options = {

    services.xrdp = {

      enable = mkEnableOption "xrdp, the Remote Desktop Protocol server";

      package = mkOption {
        type = types.package;
        default = pkgs.xrdp;
        defaultText = "pkgs.xrdp";
        description = ''
          The package to use for the xrdp daemon's binary.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 3389;
        description = ''
          Specifies on which port the xrdp daemon listens.
        '';
      };

      sslKey = mkOption {
        type = types.str;
        default = "/etc/xrdp/key.pem";
        example = "/path/to/your/key.pem";
        description = ''
          ssl private key path
          A self-signed certificate will be generated if file not exists.
        '';
      };

      sslCert = mkOption {
        type = types.str;
        default = "/etc/xrdp/cert.pem";
        example = "/path/to/your/cert.pem";
        description = ''
          ssl certificate path
          A self-signed certificate will be generated if file not exists.
        '';
      };

      sessionName = mkOption {
        type = types.str;
        default = sessionData.autologinSession;
        defaultText = "default desktop session";
        description = ''
          Name of the session to be launched.
        '';
      };

      sessionCommand = mkOption {
        type = types.str;
        default = ''${sessionData.wrapper} "$session_command"'';
        defaultText = "sessionWrapper $session_command";
        example = "xfce4-session";
        description = ''
          Command to run to start session.
        '';
      };

      globals = mkOption {
        type = types.attrsOf stringIntOrBool;
        default = {};
        description = "Global configuration option.";
      };

      logging = mkOption {
        type = types.attrsOf stringIntOrBool;
        default = {};
        description = "Logging configuration options.";
      };

      channels = mkOption {
        type = types.attrsOf types.bool;
        default = {};
        description = "Attribute set of channels to enable.";
      };

      sessions = {
        xorg = mkOption {
          type = types.attrsOf stringIntOrBool;
          default = {};
          description = "Attribute set of Xorg session options.";
        };
      };

      sesman = {
        globals = mkOption {
          type = types.attrsOf stringIntOrBool;
          default = {};
          description = "Xrdp sesman global configuration options.";
        };

        security = mkOption {
          type = types.attrsOf stringIntOrBool;
          default = {};
          description = "Xrdp sesman security configuration options.";
        };

        logging = mkOption {
          type = types.attrsOf stringIntOrBool;
          default = {};
          description = "Xrdp sesman logging configuration options.";
        };

        sessions = mkOption {
          type = types.attrsOf stringIntOrBool;
          default = {};
          description = "Attribute set of session options.";
        };

        chansrv = mkOption {
          type = types.attrsOf stringIntOrBool;
          default = {};
          description = "Attribute set of chansrv options.";
        };

        xorg = {
          modules = mkOption {
            type = types.listOf types.package;
            default = with pkgs; [ xorgxrdp xorg.xorgserver ];
            description = ''
              Packages to be added to the module search path of the X server.
            '';
          };

          configFile = mkOption {
            type = types.path;
            default = "${pkgs.xorgxrdp}/etc/X11/xrdp/xorg.conf";
            description = ''
              Path to xorg configuration.
            '';
          };

          params = mkOption {
            type = types.listOf types.str;
            default = [];
            description = "Lits of additional xorg parameters.";
          };
        };

        sessionVariables = mkOption {
          type = types.attrsOf types.str;
          description = "Attribute set of session variables to pass to session";
        };
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    services.xrdp = {
      globals = mkAllOptionDefault {
        ini_version = 1;
        fork = true;
        port = cfg.port;
        use_vsock = false;
        tcp_nodelay = true;
        tcp_keepalive = true;

        security_layer = "negotiate";
        crypt_level = "none";
        certificate = cfg.sslCert;
        key_file = cfg.sslKey;

        allow_channels = true;
        allow_multimon = true;
        bitmap_cache = true;
        bitmap_compression = true;
        bulk_compression = true;
        max_bpp = 32;
        new_cursor = true;
        use_fastpath = "both";
      };

      channels = mkAllOptionDefault {
        rdpdr = true;
        rdpsnd = true;
        drdynvc = true;
        cliprdr = true;
        rail = true;
        xrdpvr = true;
        tcutils = true;
      };

      logging = mkAllOptionDefault {
        LogFile = "/dev/null";
        LogLevel = "DEBUG";
        EnableSyslog = true;
        SyslogLevel = "DEBUG";
      };

      sessions = {
        xorg = mkAllOptionDefault {
          name = "Xorg";
          lib = "libxup.so";
          username = "ask";
          password = "ask";
          ip = "127.0.0.1";
          sesmanport = 3350;
          code = 20;
        };
      };

      sesman = {
        globals = mkAllOptionDefault {
          ListenAddress = "127.0.0.1";
          ListenPort = 3350;
          EnableUserWindowManager = true;
          UserWindowManager = "startwm.sh";
          DefaultWindowManager = "startwm.sh";
        };

        security = mkAllOptionDefault {
          AllowRootLogin = true;
          MaxLoginRetry = 4;
          TerminalServerUsers = "tsusers";
          TerminalServerAdmins = "tsadmins";
          AlwaysGroupCheck = false;
        };

        sessions = mkAllOptionDefault {
          X11DisplayOffset = 10;
          MaxSessions = 50;
          KillDisconnected = true;
          DisconnectedTimeLimit = 0;
          IdleTimeLimit = 0;
          Policy = "Default";
        };

        logging = mkAllOptionDefault {
          LogFile = "/dev/null";
          LogLevel = "DEBUG";
          EnableSyslog = true;
          SyslogLevel = "DEBUG";
        };

        chansrv = mkAllOptionDefault {
          FuseMountName = "thinclient_drives";
          FileUmask = 077;
        };

        sessionVariables = {
          PULSE_SCRIPT = mkOptionDefault "/etc/xrdp/pulse/default.pa";
        };

        xorg = {
          params = [
            "${pkgs.xorg.xorgserver}/bin/Xorg"
            "-modulepath"
            "${concatMapStringsSep "," (x: "${x}/lib/xorg/modules") cfg.sesman.xorg.modules}"
            "-config"
            cfg.sesman.xorg.configFile
            "-noreset"
            "-nolisten"
            "tcp"
            "-logfile"
            ".xorgxrdp.%s.log"
          ];
        };
      };
    };

    # xrdp can run X11 program even if "services.xserver.enable = false"
    xdg = {
      autostart.enable = true;
      menus.enable = true;
      mime.enable = true;
      icons.enable = true;
    };

    fonts.enableDefaultFonts = mkDefault true;

    environment.etc = {
      "xrdp/xrdp.ini".text = xrdpIni;
      "xrdp/sesman.ini".text = sesmanIni;
      "xrdp/startwm.sh".source = startwm;

      "xrdp/xrdp_keyboard.ini".source = "${cfg.package}/etc/xrdp/xrdp_keyboard.ini";
      "xrdp/pulse/default.pa".source = "${cfg.package}/etc/xrdp/pulse/default.pa";
    } // (mapAttrs (k: _: {
      target = "xrdp/${k}";
      source = "${pkgs.xrdp}/etc/xrdp/${k}";
    }) kmFiles);

    systemd = {
      services.xrdp = {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" "xrdp-sesman.service" ];
        description = "xrdp daemon";
        preStart = ''
          # create run directory
          mkdir -p /run/xrdp
          chown xrdp:xrdp /run/xrdp

          # prepare directory for unix sockets (the sockets will be owned by loggedinuser:xrdp)
          mkdir -p /tmp/.xrdp || true
          chown xrdp:xrdp /tmp/.xrdp
          chmod 3777 /tmp/.xrdp

          # generate a self-signed certificate
          if [ ! -s ${cfg.sslCert} -o ! -s ${cfg.sslKey} ]; then
            mkdir -p $(dirname ${cfg.sslCert}) || true
            mkdir -p $(dirname ${cfg.sslKey}) || true
            ${pkgs.openssl.bin}/bin/openssl req -x509 -newkey rsa:2048 -sha256 -nodes -days 365 \
              -subj /C=US/ST=CA/L=Sunnyvale/O=xrdp/CN=www.xrdp.org \
              -config ${cfg.package}/share/xrdp/openssl.conf \
              -keyout ${cfg.sslKey} -out ${cfg.sslCert}
            chown root:xrdp ${cfg.sslKey} ${cfg.sslCert}
            chmod 440 ${cfg.sslKey} ${cfg.sslCert}
          fi

          # generate rsa keys
          if [ ! -s /run/xrdp/rsakeys.ini ]; then
            mkdir -p /run/xrdp
            ${cfg.package}/bin/xrdp-keygen xrdp /run/xrdp/rsakeys.ini
          fi
        '';
        serviceConfig = {
          Type = "forking";
          PIDFile = "/run/xrdp/xrdp.pid";
          ExecStart = "${cfg.package}/bin/xrdp";
          ExecStop = "${cfg.package}/bin/xrdp --kill";
          User = "xrdp";
          Group = "xrdp";
          PermissionsStartOnly = true;
        };
      };

      services.xrdp-sesman = {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        bindsTo = [ "xrdp.service" ];
        description = "xrdp session manager";
        restartIfChanged = false; # do not restart on "nixos-rebuild switch". like "display-manager", it can have many interactive programs as children
        preStart = ''
          # create run directory
          mkdir -p /run/xrdp
          chown xrdp:xrdp /run/xrdp
        '';
        serviceConfig = {
          Type = "forking";
          PIDFile = "/run/xrdp/xrdp-sesman.pid";
          ExecStart = "${cfg.package}/bin/xrdp-sesman";
          ExecStop  = "${cfg.package}/bin/xrdp-sesman --kill";
        };
      };

    };

    users.users.xrdp = {
      description   = "xrdp daemon user";
      isSystemUser  = true;
      group         = "xrdp";
    };
    users.groups.xrdp = {};

    security.pam.services.xrdp-sesman = { allowNullPassword = true; startSession = true; };
  };

}
