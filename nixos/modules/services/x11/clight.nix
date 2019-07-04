{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.clight;

  toConf = v:
    if builtins.isFloat v then toString v
    else if isInt v       then toString v
    else if isBool v      then boolToString v
    else if isString v    then ''"${escape [''"''] v}"''
    else if isList v      then "[ " + concatMapStringsSep ", " toConf v + " ]"
    else abort "clight.toConf: unexpected type (v = ${v})";

  clightConf = pkgs.writeText "clight.conf"
    (concatStringsSep "\n" (mapAttrsToList
      (name: value: "${toString name} = ${toConf value};")
      (filterAttrs
        (_: value: value != null)
        cfg.settings)));
in {
  options.services.clight = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable clight or not.
      '';
    };

    temperature = {
      day = mkOption {
        type = types.int;
        default = 5500;
        description = ''
          Colour temperature to use during the day, between
          <literal>1000</literal> and <literal>25000</literal> K.
        '';
      };
      night = mkOption {
        type = types.int;
        default = 3700;
        description = ''
          Colour temperature to use at night, between
          <literal>1000</literal> and <literal>25000</literal> K.
        '';
      };
    };

    settings = let
      validConfigTypes = with types; either int (either str (either bool float));
    in mkOption {
      type = with types; attrsOf (nullOr (either validConfigTypes (listOf validConfigTypes)));
      default = {};
      example = { captures = 20; gamma_long_transition = true; ac_capture_timeouts = [ 120 300 60 ]; };
      description = ''
        Additional configuration to extend clight.conf. See
        <link xlink:href="https://github.com/FedeDP/Clight/blob/master/Extra/clight.conf"/> for a
        sample configuration file.
      '';
    };
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "i2c_dev" ];
    environment.systemPackages = with pkgs; [ clight clightd ];
    services.dbus.packages = with pkgs; [ clight clightd ];
    services.upower.enable = true;

    services.clight.settings = {
      gamma_temp = with cfg.temperature; mkDefault [ day night ];
    } // (optionalAttrs (config.location.provider == "manual") {
      latitude = mkDefault config.location.latitude;
      longitude = mkDefault config.location.longitude;
    });

    services.geoclue2.appConfig."clightc" = {
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
      after = [ "upower.service" "clightd.service" ];
      wants = [ "upower.service" "clightd.service" ];
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
