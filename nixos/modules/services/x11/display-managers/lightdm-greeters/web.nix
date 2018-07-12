{ config, lib, pkgs, ... }:

with lib;

let

  dmcfg = config.services.xserver.displayManager;
  ldmcfg = dmcfg.lightdm;
  cfg = ldmcfg.greeters.web;

  cfgFile = pkgs.writeText "web-greeter-yml" ''
    #
    # branding:
    #     background_images_dir: Path to directory that contains background images for use by themes.
    #     logo_image:            Path to logo image for use by greeter themes.
    #     user_image:            Default user image/avatar. This is used by themes when user has no .face image.
    #
    # NOTE: Paths must be accessible to the lightdm system user account (so they cannot be anywhere in /home)
    #
    branding:
        background_images_dir: '/run/current-system/sw/share/backgrounds'
        logo_image: '/run/current-system/sw/share/web-greeter/themes/default/antergos-logo-user.png'
        user_image: '/run/current-system/sw/share/web-greeter/themes/default/antergos.png'

    #
    # greeter:
    #     debug_mode:          Enable debug mode for the greeter as well as greeter themes.
    #     detect_theme_errors: Provide an option to load a fallback theme when theme errors are detected.
    #     screensaver_timeout: Blank the screen after this many seconds of inactivity.
    #     secure_mode:         Don't allow themes to make remote http requests.
    #     theme:               Greeter theme to use.
    #     time_format:         A moment.js format string so the greeter can generate localized time for display.
    #     time_language:       Language to use when displaying the time or "auto" to use the system's language.
    #
    # NOTE: See moment.js documentation for format string options: http://momentjs.com/docs/#/displaying/format
    #
    greeter:
        debug_mode: False
        detect_theme_errors: True
        screensaver_timeout: 300
        secure_mode: True
        theme: ${cfg.theme.name}
        time_format: LT
        time_language: auto
  '';

  inherit (pkgs) stdenv lightdm writeScript writeText;

  theme = cfg.theme.package;

  wrappedWebGreeter = pkgs.runCommand "lightdm-web-greeter"
    { buildInputs = [ pkgs.makeWrapper ]; }
    ''
      # This wrapper ensures that we actually get themes
      makeWrapper ${pkgs.lightdm-web-greeter}/bin/web-greeter \
        $out/greeter \
        --prefix PATH : "${pkgs.glibc.bin}/bin"

      cat - > $out/lightdm-web-greeter.desktop << EOF
      [Desktop Entry]
      Name=LightDM Greeter
      Comment=This runs the LightDM Greeter
      Exec=$out/greeter
      Type=Application
      EOF
    '';

in
{
  options = {
    services.xserver.displayManager.lightdm.greeters.web = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable lightdm-web-greeter as the lightdm greeter.
        '';
      };

      theme = {
        package = mkOption {
          type = types.package;
          default =      pkgs.lightdm-web-greeter.theme;
          defaultText = "pkgs.lightdm-web-greeter.theme";
          description = ''
            The package path that contains the theme given in the name option.
          '';
        };

        name = mkOption {
          type = types.str;
          default = "default";
          description = ''
            Name of the theme to use for the lightdm-web-greeter.
          '';
        };
      };
    };
  };

  config = mkIf (ldmcfg.enable && cfg.enable) {
    services.xserver.displayManager.lightdm.greeter = mkDefault {
      package = wrappedWebGreeter;
      name = "lightdm-web-greeter";
    };
    environment.etc."lightdm/web-greeter.yml".source = cfgFile;
    environment.systemPackages = [
      cfg.theme.package
    ];
    environment.pathsToLink = [
      "/share/web-greeter"
    ];
  };
}
