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
      description = lib.mdDoc ''
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

    package = lib.mkPackageOptionMD pkgs [ "greetd" "regreet" ] { };

    settings = lib.mkOption {
      type = lib.types.either lib.types.path settingsFormat.type;
      default = { };
      description = lib.mdDoc ''
        ReGreet configuration file. Refer
        <https://github.com/rharish101/ReGreet/blob/main/regreet.sample.toml>
        for options.
      '';
    };

    extraCss = lib.mkOption {
      type = lib.types.either lib.types.path lib.types.lines;
      default = "";
      description = lib.mdDoc ''
        Extra CSS rules to apply on top of the GTK theme. Refer to
        [GTK CSS Properties](https://docs.gtk.org/gtk4/css-properties.html) for
        modifiable properties.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = lib.mkDefault true;
      settings.default_session.command = lib.mkDefault "${pkgs.dbus}/bin/dbus-run-session ${lib.getExe pkgs.cage} -s -- ${lib.getExe cfg.package}";
    };

    environment.etc = {
      "greetd/regreet.css" =
        if lib.isPath cfg.extraCss
        then {source = cfg.extraCss;}
        else {text = cfg.extraCss;};

      "greetd/regreet.toml".source =
        if lib.isPath cfg.settings
        then cfg.settings
        else settingsFormat.generate "regreet.toml" cfg.settings;
    };

    systemd.tmpfiles.rules = let
      user = config.services.greetd.settings.default_session.user;
    in [
      "d /var/log/regreet 0755 greeter ${user} - -"
      "d /var/cache/regreet 0755 greeter ${user} - -"
    ];
  };
}
