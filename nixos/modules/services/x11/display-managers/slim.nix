{ config, lib, pkgs, ... }:

with lib;

let

  dmcfg = config.services.xserver.displayManager;

  cfg = dmcfg.slim;

  slimConfig = pkgs.writeText "slim.cfg"
    ''
      xauth_path ${dmcfg.xauthBin}
      default_xserver ${dmcfg.xserverBin}
      xserver_arguments ${toString dmcfg.xserverArgs}
      sessiondir ${dmcfg.session.desktops}/share/xsessions
      login_cmd exec ${pkgs.runtimeShell} ${dmcfg.session.wrapper} "%session"
      halt_cmd ${config.systemd.package}/sbin/shutdown -h now
      reboot_cmd ${config.systemd.package}/sbin/shutdown -r now
      logfile /dev/stderr
      ${optionalString (cfg.defaultUser != null) ("default_user " + cfg.defaultUser)}
      ${optionalString (cfg.defaultUser != null) ("focus_password yes")}
      ${optionalString cfg.autoLogin "auto_login yes"}
      ${optionalString (cfg.consoleCmd != null) "console_cmd ${cfg.consoleCmd}"}
      ${cfg.extraConfig}
    '';

  # Unpack the SLiM theme, or use the default.
  slimThemesDir =
    let
      unpackedTheme = pkgs.runCommand "slim-theme" { preferLocalBuild = true; }
        ''
          mkdir -p $out
          cd $out
          unpackFile ${cfg.theme}
          ln -s * default
        '';
    in if cfg.theme == null then "${pkgs.slim}/share/slim/themes" else unpackedTheme;

in

{

  ###### interface

  options = {

    services.xserver.displayManager.slim = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable SLiM as the display manager.
        '';
      };

      theme = mkOption {
        type = types.nullOr types.path;
        default = pkgs.fetchurl {
          url = "https://github.com/jagajaga/nixos-slim-theme/archive/2.0.tar.gz";
          sha256 = "0lldizhigx7bjhxkipii87y432hlf5wdvamnfxrryf9z7zkfypc8";
        };
        defaultText = ''pkgs.fetchurl {
          url = "https://github.com/jagajaga/nixos-slim-theme/archive/2.0.tar.gz";
          sha256 = "0lldizhigx7bjhxkipii87y432hlf5wdvamnfxrryf9z7zkfypc8";
        }'';
        example = literalExample ''
          pkgs.fetchurl {
            url = "mirror://sourceforge/slim.berlios/slim-wave.tar.gz";
            sha256 = "0ndr419i5myzcylvxb89m9grl2xyq6fbnyc3lkd711mzlmnnfxdy";
          }
        '';
        description = ''
          The theme for the SLiM login manager.  If not specified, SLiM's
          default theme is used.  See <link
          xlink:href='http://slim.berlios.de/themes01.php'/> for a
          collection of themes. TODO: berlios shut down.
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

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration options for SLiM login manager. Do not
          add options that can be configured directly.
        '';
      };

      consoleCmd = mkOption {
        type = types.nullOr types.str;
        default = ''
          ${pkgs.xterm}/bin/xterm -C -fg white -bg black +sb -T "Console login" -e ${pkgs.shadow}/bin/login
        '';
        defaultText = ''
          ''${pkgs.xterm}/bin/xterm -C -fg white -bg black +sb -T "Console login" -e ''${pkgs.shadow}/bin/login
        '';
        description = ''
          The command to run when "console" is given as the username.
        '';
      };
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.xserver.displayManager.job =
      { environment =
          { SLIM_CFGFILE = slimConfig;
            SLIM_THEMESDIR = slimThemesDir;
          };
        execCmd = "exec ${pkgs.slim}/bin/slim";
      };

    services.xserver.displayManager.sessionCommands =
      ''
        # Export the config/themes for slimlock.
        export SLIM_THEMESDIR=${slimThemesDir}
      '';

    # Allow null passwords so that the user can login as root on the
    # installation CD.
    security.pam.services.slim = { allowNullPassword = true; startSession = true; };

    # Allow slimlock to work.
    security.pam.services.slimlock = {};

    environment.systemPackages = [ pkgs.slim ];

  };

}
