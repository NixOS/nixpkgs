{ config, pkgs, ... }:

with pkgs.lib;

let

  dmcfg = config.services.xserver.displayManager;
  cfg = dmcfg.kdm;

  inherit (pkgs.kde4) kdebase_workspace;

  defaultConfig =
    ''
      [Shutdown]
      HaltCmd=${config.systemd.package}/sbin/shutdown -h now
      RebootCmd=${config.systemd.package}/sbin/shutdown -r now
      ${optionalString (config.system.boot.loader.id == "grub") ''
        BootManager=${if config.boot.loader.grub.version == 2 then "Grub2" else "Grub"}
      ''}

      [X-*-Core]
      Xrdb=${pkgs.xlibs.xrdb}/bin/xrdb
      SessionsDirs=${dmcfg.session.desktops}
      Session=${dmcfg.session.script}
      FailsafeClient=${pkgs.xterm}/bin/xterm

      [X-:*-Core]
      ServerCmd=${dmcfg.xserverBin} ${dmcfg.xserverArgs}
      # KDM calls `rm' somewhere to clean up some temporary directory.
      SystemPath=${pkgs.coreutils}/bin
      # The default timeout (15) is too short in a heavily loaded boot process.
      ServerTimeout=60
      # Needed to prevent the X server from dying on logout and not coming back:
      TerminateServer=true
      ${optionalString (cfg.setupScript != "")
      ''
        Setup=${cfg.setupScript}
      ''} 

      [X-*-Greeter]
      HiddenUsers=root,nixbld1,nixbld2,nixbld3,nixbld4,nixbld5,nixbld6,nixbld7,nixbld8,nixbld9,nixbld10
      PluginsLogin=${kdebase_workspace}/lib/kde4/kgreet_classic.so
      ${optionalString (cfg.themeDirectory != "")
      ''
        UseTheme=true
        Theme=${cfg.themeDirectory}
      ''
      }

      ${optionalString (cfg.enableXDMCP)
      ''
        [Xdmcp]
        Enable=true
      ''}
    '';

  kdmrc = pkgs.stdenv.mkDerivation {
    name = "kdmrc";
    config = defaultConfig + cfg.extraConfig;
    buildCommand =
      ''
        echo "$config" > $out

        # The default kdmrc would add "-nolisten tcp", and we already
        # have that managed by nixos. Hence the grep.
        cat ${kdebase_workspace}/share/config/kdm/kdmrc | grep -v nolisten >> $out
      '';
  };

in

{

  ###### interface

  options = {

    services.xserver.displayManager.kdm = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to enable the KDE display manager.
        '';
      };

      enableXDMCP = mkOption {
        default = false;
        description = ''
          Whether to enable XDMCP, which allows remote logins.
        '';
      };

      themeDirectory = mkOption {
        default = "";
        description = ''
          The path to a KDM theme directory. This theme
          will be used by the KDM greeter.
        '';
      };

      setupScript = mkOption {
        default = "";
        description = ''
          The path to a KDM setup script. This script is run as root just
          before KDM starts. Can be used for setting up
          monitors with xrandr, for example.
        '';
      };

      extraConfig = mkOption {
        default = "";
        description = ''
          Options appended to <filename>kdmrc</filename>, the
          configuration file of KDM.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.xserver.displayManager.slim.enable = false;

    services.xserver.displayManager.job =
      { execCmd = mkFixStrictness
          ''
            mkdir -m 0755 -p /var/lib/kdm
            chown kdm /var/lib/kdm
            ${(optionalString (config.system.boot.loader.id == "grub" && config.system.build.grub != null) "PATH=${config.system.build.grub}/sbin:$PATH ") +
              "KDEDIRS=/run/current-system/sw exec ${kdebase_workspace}/bin/kdm -config ${kdmrc} -nodaemon"}
          '';
        logsXsession = true;
      };

    security.pam.services.kde = { allowNullPassword = true; startSession = true; };

    users.extraUsers = singleton
      { name = "kdm";
        uid = config.ids.uids.kdm;
        description = "KDM user";
      };

  };

}
