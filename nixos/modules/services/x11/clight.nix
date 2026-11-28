{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.services.clight;

  configFormat = pkgs.formats.libconfig { };

  isLibconfigMarker =
    value:
    isAttrs value
    &&
      builtins.attrNames value == [
        "_type"
        "value"
      ]
    && isString value._type
    && (
      (
        elem value._type [
          "array"
          "list"
        ]
        && isList value.value
      )
      || (
        elem value._type [
          "hex"
          "octal"
          "float"
        ]
        && isString value.value
      )
    );

  toLibconfig =
    value:
    if isLibconfigMarker value then
      value
    else if isList value then
      let
        converted = map toLibconfig value;
      in
      if all (v: !isAttrs v && !isList v) value then configFormat.lib.mkArray converted else converted
    else if isAttrs value then
      mapAttrs (_: toLibconfig) value
    else
      value;

  clightConf = configFormat.generate "clight.conf" (
    toLibconfig (filterAttrs (_: value: value != null) cfg.settings)
  );
in
{
  options.services.clight = {
    enable = mkEnableOption "clight";

    temperature = {
      day = mkOption {
        type = types.int;
        default = 5500;
        description = ''
          Colour temperature to use during the day, between
          `1000` and `25000` K.
        '';
      };
      night = mkOption {
        type = types.int;
        default = 3700;
        description = ''
          Colour temperature to use at night, between
          `1000` and `25000` K.
        '';
      };
    };

    settings = mkOption {
      type = types.attrsOf (types.nullOr configFormat.type.nestedTypes.elemType);
      default = { };
      example = {
        captures = 20;
        gamma_long_transition = true;
        ac_capture_timeouts = [
          120
          300
          60
        ];
        monitor_override = [
          {
            monitor_id = "example_1";
            ac_regression_points = [
              0.0
              0.1
              0.2
            ];
          }
        ];
      };
      description = ''
        Additional configuration to extend clight.conf. See
        <https://github.com/FedeDP/Clight/blob/master/Extra/clight.conf> for a
        sample configuration file.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions =
      let
        inRange =
          v: l: r:
          v >= l && v <= r;
      in
      [
        {
          assertion =
            config.location.provider == "manual"
            -> inRange config.location.latitude (-90) 90 && inRange config.location.longitude (-180) 180;
          message = "You must specify a valid latitude and longitude if manually providing location";
        }
      ];

    boot.kernelModules = [ "i2c_dev" ];
    environment.systemPackages = with pkgs; [
      clight
      clightd
    ];
    services.dbus.packages = with pkgs; [
      clight
      clightd
    ];
    services.upower.enable = true;

    services.clight.settings = {
      gamma.temp =
        with cfg.temperature;
        mkDefault [
          day
          night
        ];
    }
    // (optionalAttrs (config.location.provider == "manual") {
      daytime.latitude = mkDefault config.location.latitude;
      daytime.longitude = mkDefault config.location.longitude;
    });

    services.geoclue2.appConfig.clightc = {
      isAllowed = true;
      isSystem = true;
    };

    systemd.services.clightd = {
      requires = [ "polkit.service" ];
      wantedBy = [ "multi-user.target" ];

      description = "Bus service to manage various screen related properties (gamma, dpms, backlight)";
      serviceConfig = {
        Type = "dbus";
        BusName = "org.clightd.clightd";
        Restart = "on-failure";
        RestartSec = 5;
        ExecStart = ''
          ${pkgs.clightd}/bin/clightd
        '';
      };
    };

    systemd.user.services.clight = {
      after = [
        "upower.service"
        "clightd.service"
      ];
      wants = [
        "upower.service"
        "clightd.service"
      ];
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];

      description = "C daemon to adjust screen brightness to match ambient brightness, as computed capturing frames from webcam";
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 5;
        ExecStart = ''
          ${pkgs.clight}/bin/clight --conf-file ${clightConf}
        '';
      };
    };
  };
}
