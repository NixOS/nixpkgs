{ config, pkgs, ... }:

with pkgs.lib;

let

  dmcfg = config.services.xserver.displayManager;
  cfg = dmcfg.slim;

  slimConfig = pkgs.writeText "slim.cfg"
    ''
      xauth_path ${dmcfg.xauthBin}
      default_xserver ${dmcfg.xserverBin}
      xserver_arguments ${dmcfg.xserverArgs}
      sessiondir ${dmcfg.session.desktops}
      login_cmd exec ${pkgs.stdenv.shell} ${dmcfg.session.script} "%session"
      halt_cmd ${config.systemd.package}/sbin/shutdown -h now
      reboot_cmd ${config.systemd.package}/sbin/shutdown -r now
      ${optionalString (cfg.defaultUser != null) ("default_user " + cfg.defaultUser)}
      ${optionalString cfg.autoLogin "auto_login yes"}
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
        type = types.bool;
        default = config.services.xserver.enable;
        description = ''
          Whether to enable SLiM as the display manager.
        '';
      };

      theme = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = literalExample ''
          pkgs.fetchurl {
            url = http://download.berlios.de/slim/slim-wave.tar.gz;
            sha256 = "0ndr419i5myzcylvxb89m9grl2xyq6fbnyc3lkd711mzlmnnfxdy";
          }
        '';
        description = ''
          The theme for the SLiM login manager.  If not specified, SLiM's
          default theme is used.  See <link
          xlink:href='http://slim.berlios.de/themes01.php'/> for a
          collection of themes.
        '';
      };

      defaultUser = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "login";
        description = ''
          The default user to load. If you put a username here you
          get it automatically loaded into the username field, and
          the focus is placed on the password.
        '';
      };

      autoLogin = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Automatically log in as the default user.
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
        execCmd = "exec ${pkgs.slim}/bin/slim";
      };

    # Allow null passwords so that the user can login as root on the
    # installation CD.
    security.pam.services.slim = { allowNullPassword = true; startSession = true; };

    # Allow slimlock to work.
    security.pam.services.slimlock = {};

    environment.systemPackages = [ pkgs.slim ];

  };

}
