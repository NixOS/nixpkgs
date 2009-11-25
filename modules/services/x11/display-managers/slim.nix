{pkgs, config, ...}:

with pkgs.lib;

let

  dmcfg = config.services.xserver.displayManager;
  cfg = dmcfg.slim;

  slimConfig = pkgs.writeText "slim.cfg"
    ''
      xauth_path ${dmcfg.xauthBin}
      default_xserver ${dmcfg.xserverBin}
      xserver_arguments ${dmcfg.xserverArgs}
      sessions ${pkgs.lib.concatStringsSep "," (dmcfg.session.names ++ ["custom"])}
      login_cmd exec ${pkgs.stdenv.bash}/bin/sh ${dmcfg.session.script} "%session"
      halt_cmd ${config.system.build.upstart}/sbin/shutdown -h now
      reboot_cmd ${config.system.build.upstart}/sbin/shutdown -r now
      ${if cfg.defaultUser != "" then "default_user " + cfg.defaultUser else ""}
      ${if cfg.hideCursor then "hidecursor true" else ""}
    '';

  # Unpack the SLiM theme, or use the default.
  slimThemesDir =
    let
      unpackedTheme = pkgs.stdenv.mkDerivation {
        name = "slim-theme";
        buildCommand = ''
          ensureDir $out
          cd $out
          unpackFile ${cfg.theme}
          ln -s * default
        '';
      };
    in if cfg.theme == null then "${pkgs.slim}/share/slim/themes" else unpackedTheme;

in

{

  ###### interface

  options = {
  
    services.xserver.displayManager.slim = {
    
      enable = mkOption {
        default = true;
        description = ''
          Whether to enable SLiM as the display manager.
        '';
      };

      theme = mkOption {
        default = null;
        example = pkgs.fetchurl {
          url = http://download.berlios.de/slim/slim-wave.tar.gz;
          sha256 = "0ndr419i5myzcylvxb89m9grl2xyq6fbnyc3lkd711mzlmnnfxdy";
        };
        description = ''
          The theme for the SLiM login manager.  If not specified, SLiM's
          default theme is used.  See <link
          xlink:href='http://slim.berlios.de/themes01.php'/> for a
          collection of themes.
        '';
      };

      defaultUser = mkOption {
        default = "";
        example = "login";
        description = ''
          The default user to load. If you put a username here you
          get it automatically loaded into the username field, and
          the focus is placed on the password.
        '';
      };

      hideCursor = mkOption {
        default = false;
        example = true;
        description = ''
          Hide the mouse cursor on the login screen.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.xserver.displayManager.job =
      { preStart =
          ''
            rm -f /var/log/slim.log
          '';
        environment =
          { SLIM_CFGFILE = slimConfig;
            SLIM_THEMESDIR = slimThemesDir;
          };
        execCmd = "${pkgs.slim}/bin/slim";
      };

    # Allow null passwords so that the user can login as root on the
    # installation CD.
    security.pam.services = [ { name = "slim"; allowNullPassword = true; } ];

  };

}
