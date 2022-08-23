{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xrdp;
  confDir = pkgs.runCommand "xrdp.conf" { preferLocalBuild = true; } ''
    mkdir $out

    cp ${cfg.package}/etc/xrdp/{km-*,xrdp,sesman,xrdp_keyboard}.ini $out

    cat > $out/startwm.sh <<EOF
    #!/bin/sh
    . /etc/profile
    ${cfg.defaultWindowManager}
    EOF
    chmod +x $out/startwm.sh

    substituteInPlace $out/xrdp.ini \
      --replace "#rsakeys_ini=" "rsakeys_ini=/run/xrdp/rsakeys.ini" \
      --replace "certificate=" "certificate=${cfg.sslCert}" \
      --replace "key_file=" "key_file=${cfg.sslKey}" \
      --replace LogFile=xrdp.log LogFile=/dev/null \
      --replace EnableSyslog=true EnableSyslog=false

    substituteInPlace $out/sesman.ini \
      --replace LogFile=xrdp-sesman.log LogFile=/dev/null \
      --replace EnableSyslog=1 EnableSyslog=0

    # Ensure that clipboard works for non-ASCII characters
    sed -i -e '/.*SessionVariables.*/ a\
    LANG=${config.i18n.defaultLocale}\
    LOCALE_ARCHIVE=${config.i18n.glibcLocales}/lib/locale/locale-archive
    ' $out/sesman.ini
  '';
in
{

  ###### interface

  options = {

    services.xrdp = {

      enable = mkEnableOption "xrdp, the Remote Desktop Protocol server";

      package = mkOption {
        type = types.package;
        default = pkgs.xrdp;
        defaultText = literalExpression "pkgs.xrdp";
        description = lib.mdDoc ''
          The package to use for the xrdp daemon's binary.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 3389;
        description = lib.mdDoc ''
          Specifies on which port the xrdp daemon listens.
        '';
      };

      openFirewall = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc "Whether to open the firewall for the specified RDP port.";
      };

      sslKey = mkOption {
        type = types.str;
        default = "/etc/xrdp/key.pem";
        example = "/path/to/your/key.pem";
        description = lib.mdDoc ''
          ssl private key path
          A self-signed certificate will be generated if file not exists.
        '';
      };

      sslCert = mkOption {
        type = types.str;
        default = "/etc/xrdp/cert.pem";
        example = "/path/to/your/cert.pem";
        description = lib.mdDoc ''
          ssl certificate path
          A self-signed certificate will be generated if file not exists.
        '';
      };

      defaultWindowManager = mkOption {
        type = types.str;
        default = "xterm";
        example = "xfce4-session";
        description = lib.mdDoc ''
          The script to run when user log in, usually a window manager, e.g. "icewm", "xfce4-session"
          This is per-user overridable, if file ~/startwm.sh exists it will be used instead.
        '';
      };

      confDir = mkOption {
        type = types.path;
        default = confDir;
        defaultText = literalDocBook "generated from configuration";
        description = lib.mdDoc "The location of the config files for xrdp.";
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

    # xrdp can run X11 program even if "services.xserver.enable = false"
    xdg = {
      autostart.enable = true;
      menus.enable = true;
      mime.enable = true;
      icons.enable = true;
    };

    fonts.enableDefaultFonts = mkDefault true;

    systemd = {
      services.xrdp = {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        description = "xrdp daemon";
        requires = [ "xrdp-sesman.service" ];
        preStart = ''
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
          if [ ! -s /run/xrdp/rsakeys.ini ]; then
            mkdir -p /run/xrdp
            ${cfg.package}/bin/xrdp-keygen xrdp /run/xrdp/rsakeys.ini
          fi
        '';
        serviceConfig = {
          User = "xrdp";
          Group = "xrdp";
          PermissionsStartOnly = true;
          ExecStart = "${cfg.package}/bin/xrdp --nodaemon --port ${toString cfg.port} --config ${cfg.confDir}/xrdp.ini";
        };
      };

      services.xrdp-sesman = {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        description = "xrdp session manager";
        restartIfChanged = false; # do not restart on "nixos-rebuild switch". like "display-manager", it can have many interactive programs as children
        serviceConfig = {
          ExecStart = "${cfg.package}/bin/xrdp-sesman --nodaemon --config ${cfg.confDir}/sesman.ini";
          ExecStop  = "${pkgs.coreutils}/bin/kill -INT $MAINPID";
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
