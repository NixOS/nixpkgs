{ lib
, pkgs
, config
, ...
}:
let
  cfg = config.programs.regreet;
  settingsFormat = pkgs.formats.toml { };
in
{
  options.programs.regreet = {
    enable = lib.mkEnableOption null // {
      description = ''
        Enable ReGreet, a clean and customizable greeter for greetd.

        To use ReGreet, {option}`services.greetd` has to be enabled and
        {option}`services.greetd.settings.default_session` should contain the
        appropriate configuration to launch
        {option}`config.programs.regreet.package`. For examples, see the
        [ReGreet Readme](https://github.com/rharish101/ReGreet#set-as-default-session).

        A minimal configuration that launches ReGreet in {command}`cage` is
        enabled by this module by default.
      '';
    };

    package = lib.mkPackageOption pkgs [ "greetd" "regreet" ] { };

    settings = lib.mkOption {
      type = settingsFormat.type;
      default = { };
      description = ''
        ReGreet configuration file. Refer
        <https://github.com/rharish101/ReGreet/blob/main/regreet.sample.toml>
        for options.
      '';
    };

    cageArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "-s" ];
      example = lib.literalExpression
        ''
          [ "-s" "-m" "last" ]
        '';
      description = ''
        Additional arguments to be passed to
        [cage](https://github.com/cage-kiosk/cage).
      '';
    };

    extraCss = lib.mkOption {
      type = lib.types.either lib.types.path lib.types.lines;
      default = "";
      description = ''
        Extra CSS rules to apply on top of the GTK theme. Refer to
        [GTK CSS Properties](https://docs.gtk.org/gtk4/css-properties.html) for
        modifiable properties.
      '';
    };

    theme = {
      package = lib.mkPackageOption pkgs "gnome-themes-extra" { } // {
        description = ''
          The package that provides the theme given in the name option.
        '';
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "Adwaita";
        description = ''
          Name of the theme to use for regreet.
        '';
      };
    };

    iconTheme = {
      package = lib.mkPackageOption pkgs "adwaita-icon-theme" { } // {
        description = ''
          The package that provides the icon theme given in the name option.
        '';
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "Adwaita";
        description = ''
          Name of the icon theme to use for regreet.
        '';
      };
    };

    font = {
      package = lib.mkPackageOption pkgs "cantarell-fonts" { } // {
        description = ''
          The package that provides the font given in the name option.
        '';
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "Cantarell";
        description = ''
          Name of the font to use for regreet.
        '';
      };

      size = lib.mkOption {
        type = lib.types.ints.positive;
        default = 16;
        description = ''
          Size of the font to use for regreet.
        '';
      };
    };

    cursorTheme = {
      package = lib.mkPackageOption pkgs "adwaita-icon-theme" { } // {
        description = ''
          The package that provides the cursor theme given in the name option.
        '';
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "Adwaita";
        description = ''
          Name of the cursor theme to use for regreet.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.theme.package
      cfg.iconTheme.package
      cfg.cursorTheme.package
    ];

    fonts.packages = [ cfg.font.package ];

    programs.regreet.settings.GTK = {
      cursor_theme_name = cfg.cursorTheme.name;
      font_name = "${cfg.font.name} ${toString cfg.font.size}";
      icon_theme_name = cfg.iconTheme.name;
      theme_name = cfg.theme.name;
    };

    services.greetd = {
      enable = lib.mkDefault true;
      settings.default_session.command = lib.mkDefault "${pkgs.dbus}/bin/dbus-run-session ${lib.getExe pkgs.cage} ${lib.escapeShellArgs cfg.cageArgs} -- ${lib.getExe cfg.package}";
    };

    environment.etc = {
      "greetd/regreet.css" =
        if lib.isPath cfg.extraCss
        then {source = cfg.extraCss;}
        else {text = cfg.extraCss;};

      "greetd/regreet.toml".source =
        settingsFormat.generate "regreet.toml" cfg.settings;
    };

    systemd.tmpfiles.settings."10-regreet" = let
      defaultConfig = {
        user = "greeter";
        group = config.users.users.${config.services.greetd.settings.default_session.user}.group;
        mode = "0755";
      };
    in {
      "/var/log/regreet".d = defaultConfig;
      "/var/cache/regreet".d = defaultConfig;
    };
  };
}
