{
  config,
  lib,
  pkgs,
  ...
}:
let

  tzdir = "${pkgs.tzdata}/share/zoneinfo";
  nospace = str: lib.filter (c: c == " ") (lib.stringToCharacters str) == [ ];
  timezone = lib.types.nullOr (lib.types.addCheck lib.types.str nospace) // {
    description = "null or string without spaces";
  };

  lcfg = config.location;

in

{
  options = {

    time = {

      timeZone = lib.mkOption {
        default = null;
        type = timezone;
        example = "America/New_York";
        description = ''
          The time zone used when displaying times and dates. See <https://en.wikipedia.org/wiki/List_of_tz_database_time_zones>
          for a comprehensive list of possible values for this setting.

          If null, the timezone will default to UTC and can be set imperatively
          using timedatectl.
        '';
      };

      hardwareClockInLocalTime = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "If set, keep the hardware clock in local time instead of UTC.";
      };

    };

    location = {

      latitude = lib.mkOption {
        type = lib.types.float;
        description = ''
          Your current latitude, between
          `-90.0` and `90.0`. Must be provided
          along with longitude.
        '';
      };

      longitude = lib.mkOption {
        type = lib.types.float;
        description = ''
          Your current longitude, between
          between `-180.0` and `180.0`. Must be
          provided along with latitude.
        '';
      };

      provider = lib.mkOption {
        type = lib.types.enum [
          "manual"
          "geoclue2"
        ];
        default = "manual";
        description = ''
          The location provider to use for determining your location. If set to
          `manual` you must also provide latitude/longitude.
        '';
      };

    };
  };

  config = {

    environment.sessionVariables.TZDIR = "/etc/zoneinfo";

    services.geoclue2.enable = lib.mkIf (lcfg.provider == "geoclue2") true;

    # This way services are restarted when tzdata changes.
    systemd.globalEnvironment.TZDIR = tzdir;

    systemd.services.systemd-timedated.environment = lib.optionalAttrs (config.time.timeZone != null) {
      NIXOS_STATIC_TIMEZONE = "1";
    };

    # When time.timeZone is set declaratively, NixOS patches systemd-timedated
    # to reject timedatectl set-timezone (via NIXOS_STATIC_TIMEZONE). This means
    # the PropertiesChanged dbus signal for the Timezone property is never emitted
    # on activation, so running GUI applications (Thunderbird, Chromium, etc.)
    # don't pick up timezone changes until restarted. Emit the signal manually
    # after the etc activation updates the /etc/localtime symlink.
    system.activationScripts.timezone-notify = lib.mkIf (config.time.timeZone != null) (lib.stringAfter [ "etc" ] ''
      ${pkgs.systemd}/bin/busctl emit \
        /org/freedesktop/timedate1 \
        org.freedesktop.DBus.Properties \
        PropertiesChanged \
        "sa{sv}as" \
        org.freedesktop.timedate1 \
        1 \
          Timezone s ${lib.escapeShellArg config.time.timeZone} \
        0 \
        2>/dev/null || true
    '');

    environment.etc = {
      zoneinfo.source = tzdir;
    }
    // lib.optionalAttrs (config.time.timeZone != null) {
      localtime.source = "/etc/zoneinfo/${config.time.timeZone}";
      localtime.mode = "direct-symlink";
    }
    // lib.optionalAttrs config.time.hardwareClockInLocalTime {
      # Mirrors timedated
      # https://github.com/systemd/systemd/blob/afaca649ad678031a46182b0cce667cbbbf47a6d/src/timedate/timedated.c#L325-L396
      adjtime.text = ''
        0.0 0 0
        0
        LOCAL
      '';
    };
  };

}
