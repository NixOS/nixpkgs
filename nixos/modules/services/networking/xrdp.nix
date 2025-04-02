{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.xrdp;

  confDir = pkgs.runCommand "xrdp.conf" { preferLocalBuild = true; } ''
    mkdir -p $out

    cp -r ${cfg.package}/etc/xrdp/* $out
    chmod -R +w $out

    cat > $out/startwm.sh <<EOF
    #!/bin/sh
    . /etc/profile
    ${lib.optionalString cfg.audio.enable "${cfg.audio.package}/libexec/pulsaudio-xrdp-module/pulseaudio_xrdp_init"}
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
      --replace EnableSyslog=1 EnableSyslog=0 \
      --replace startwm.sh $out/startwm.sh \
      --replace reconnectwm.sh $out/reconnectwm.sh \

    # Ensure that clipboard works for non-ASCII characters
    sed -i -e '/.*SessionVariables.*/ a\
    LANG=${config.i18n.defaultLocale}\
    LOCALE_ARCHIVE=${config.i18n.glibcLocales}/lib/locale/locale-archive
    ' $out/sesman.ini

    ${cfg.extraConfDirCommands}
  '';
in
{

  ###### interface

  options = {

    services.xrdp = {

      enable = mkEnableOption "xrdp, the Remote Desktop Protocol server";

      package = mkPackageOption pkgs "xrdp" { };

      audio = {
        enable = mkEnableOption "audio support for xrdp sessions. So far it only works with PulseAudio sessions on the server side. No PipeWire support yet";
        package = mkPackageOption pkgs "pulseaudio-module-xrdp" { };
      };

      port = mkOption {
        type = types.port;
        default = 3389;
        description = ''
          Specifies on which port the xrdp daemon listens.
        '';
      };

      openFirewall = mkOption {
        default = false;
        type = types.bool;
        description = "Whether to open the firewall for the specified RDP port.";
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

      defaultWindowManager = mkOption {
        type = types.str;
        default = "xterm";
        example = "xfce4-session";
        description = ''
          The script to run when user log in, usually a window manager, e.g. "icewm", "xfce4-session"
          This is per-user overridable, if file ~/startwm.sh exists it will be used instead.
        '';
      };

      confDir = mkOption {
        type = types.path;
        default = confDir;
        internal = true;
        description = ''
          Configuration directory of xrdp and sesman.

          Changes to this must be made through extraConfDirCommands.
        '';
        readOnly = true;
      };

      extraConfDirCommands = mkOption {
        type = types.str;
        default = "";
        description = ''
          Extra commands to run on the default confDir derivation.
        '';
        example = ''
          substituteInPlace $out/sesman.ini \
            --replace LogLevel=INFO LogLevel=DEBUG \
            --replace LogFile=/dev/null LogFile=/var/log/xrdp.log
        '';
      };
    };
  };

  ###### implementation

  config = lib.mkMerge [
    (mkIf cfg.audio.enable {
      environment.systemPackages = [ cfg.audio.package ]; # needed for autostart

      hardware.pulseaudio.extraModules = [ cfg.audio.package ];
    })

    (mkIf cfg.enable {

      networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

      # xrdp can run X11 program even if "services.xserver.enable = false"
      xdg = {
        autostart.enable = true;
        menus.enable = true;
        mime.enable = true;
        icons.enable = true;
      };

      fonts.enableDefaultPackages = mkDefault true;

      environment.etc."xrdp".source = "${confDir}/*";

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
              ${lib.getExe pkgs.openssl} req -x509 -newkey rsa:2048 -sha256 -nodes -days 365 \
                -subj /C=US/ST=CA/L=Sunnyvale/O=xrdp/CN=www.xrdp.org \
                -config ${cfg.package}/share/xrdp/openssl.conf \
                -keyout ${cfg.sslKey} -out ${cfg.sslCert}
              chown root:xrdp ${cfg.sslKey} ${cfg.sslCert}
              chmod 440 ${cfg.sslKey} ${cfg.sslCert}
            fi
            if [ ! -s /run/xrdp/rsakeys.ini ]; then
              mkdir -p /run/xrdp
              ${pkgs.xrdp}/bin/xrdp-keygen xrdp /run/xrdp/rsakeys.ini
            fi
          '';
          serviceConfig = {
            User = "xrdp";
            Group = "xrdp";
            PermissionsStartOnly = true;
            ExecStart = "${pkgs.xrdp}/bin/xrdp --nodaemon --port ${toString cfg.port} --config ${confDir}/xrdp.ini";
          };
        };

        services.xrdp-sesman = {
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          description = "xrdp session manager";
          restartIfChanged = false; # do not restart on "nixos-rebuild switch". like "display-manager", it can have many interactive programs as children
          serviceConfig = {
            ExecStart = "${pkgs.xrdp}/bin/xrdp-sesman --nodaemon --config ${confDir}/sesman.ini";
            ExecStop = "${pkgs.coreutils}/bin/kill -INT $MAINPID";
          };
        };

      };

      users.users.xrdp = {
        description = "xrdp daemon user";
        isSystemUser = true;
        group = "xrdp";
      };
      users.groups.xrdp = { };

      security.pam.services.xrdp-sesman = {
        allowNullPassword = true;
        startSession = true;
      };

    })
  ];

}
