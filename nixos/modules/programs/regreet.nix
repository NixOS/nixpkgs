{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.regreet;
  settingsFormat = pkgs.formats.toml { };
  userName = config.services.greetd.settings.default_session.user;
  user = config.users.users.${userName} or { };
  dataDir =
    if lib.versionAtLeast (cfg.package.version) "0.2.0" then
      "/var/lib/regreet"
    else
      "/var/cache/regreet";
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

    package = lib.mkPackageOption pkgs "regreet" { };

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
      default = [
        "-s"
        "-d"
      ];
      example = lib.literalExpression ''
        [ "-s" "-d" "-m" "last" ]
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
    assertions = [
      {
        assertion = user != { };
        message = "regreet: user ${userName} does not exist. Please create it before referencing it.";
      }
    ];

    warnings = lib.optional ((user ? home) && (user.home == "/var/empty")) ''
      regreet: the home directory for user ${userName} is set to an immutable path.
      Consider setting
      ```
        users.users.${userName}.home = ${dataDir}; # Directory is created by this module automatically
      ```
      or using
      ```
        services.greetd.settings.default_session.user = "greeter"; # The default
      ```
    '';

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

    # Needed to fetch accounts
    services.accounts-daemon.enable = true;

    services.greetd = {
      enable = lib.mkDefault true;
      settings.default_session.command = lib.mkDefault "${pkgs.dbus}/bin/dbus-run-session ${lib.getExe pkgs.cage} ${lib.escapeShellArgs cfg.cageArgs} -- ${lib.getExe cfg.package}";
    };

    environment.etc = {
      "greetd/regreet.css" =
        if lib.isPath cfg.extraCss || lib.isStorePath cfg.extraCss then
          { source = cfg.extraCss; }
        else
          { text = cfg.extraCss; };

      "greetd/regreet.toml".source =
        if lib.isPath cfg.settings then
          cfg.settings
        else
          settingsFormat.generate "regreet.toml" cfg.settings;
    };

    systemd.tmpfiles.settings."10-regreet" =
      let
        defaultConfig = {
          user = userName;
          group = if ((user.group or "") != "") then user.group else "greeter";
          mode = "0755";
        };
      in
      {
        "/var/log/regreet".d = defaultConfig;
        ${dataDir}.d = defaultConfig;
      };

    # For GTK pipeline shader cache directory, which is created at `$HOME/.cache`.
    # By default `$HOME` is `/var/empty` though, owned by root, so GTK is unable
    # to create it. `/var/empty` is intentionally immutable on NixOS (`chattr +i`),
    # so `systemd.tmpfiles` cannot create `/var/empty/.cache` either.
    users.users = lib.mkIf (userName == "greeter") { greeter.home = lib.mkDefault dataDir; };
  };
}
