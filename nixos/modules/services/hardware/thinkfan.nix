{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.thinkfan;
  configFile = pkgs.writeText "thinkfan.conf" ''
    # ATTENTION: There is only very basic sanity checking on the configuration.
    # That means you can set your temperature limits as insane as you like. You
    # can do anything stupid, e.g. turn off your fan when your CPU reaches 70°C.
    #
    # That's why this program is called THINKfan: You gotta think for yourself.
    #
    ######################################################################
    #
    # IBM/Lenovo Thinkpads (thinkpad_acpi, /proc/acpi/ibm)
    # ====================================================
    #
    # IMPORTANT:
    #
    # To keep your HD from overheating, you have to specify a correction value for
    # the sensor that has the HD's temperature. You need to do this because
    # thinkfan uses only the highest temperature it can find in the system, and
    # that'll most likely never be your HD, as most HDs are already out of spec
    # when they reach 55 °C.
    # Correction values are applied from left to right in the same order as the
    # temperatures are read from the file.
    #
    # For example:
    # tp_thermal /proc/acpi/ibm/thermal (0, 0, 10)
    # will add a fixed value of 10 °C the 3rd value read from that file. Check out
    # http://www.thinkwiki.org/wiki/Thermal_Sensors to find out how much you may
    # want to add to certain temperatures.

    ${cfg.fan}
    ${cfg.sensors}

    #  Syntax:
    #  (LEVEL, LOW, HIGH)
    #  LEVEL is the fan level to use (0-7 with thinkpad_acpi)
    #  LOW is the temperature at which to step down to the previous level
    #  HIGH is the temperature at which to step up to the next level
    #  All numbers are integers.
    #

    ${cfg.levels}
  '';

  thinkfan = pkgs.thinkfan.override { smartSupport = cfg.smartSupport; };

in {

  options = {

    services.thinkfan = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable thinkfan, fan controller for IBM/Lenovo ThinkPads.
        '';
      };

      smartSupport = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to build thinkfan with SMART support to read temperatures
          directly from hard disks.
        '';
      };

      sensors = mkOption {
        type = types.lines;
        default = ''
          tp_thermal /proc/acpi/ibm/thermal (0,0,10)
        '';
        description =''
          thinkfan can read temperatures from three possible sources:

            /proc/acpi/ibm/thermal
              Which is provided by the thinkpad_acpi kernel
              module (keyword tp_thermal)

            /sys/class/hwmon/*/temp*_input
              Which may be provided by any hwmon drivers (keyword
              hwmon)

            S.M.A.R.T. (requires smartSupport to be enabled)
              Which reads the temperature directly from the hard
              disk using libatasmart (keyword atasmart)

          Multiple sensors may be added, in which case they will be
          numbered in their order of appearance.
        '';
      };

      fan = mkOption {
        type = types.str;
        default = "tp_fan /proc/acpi/ibm/fan";
        description =''
          Specifies the fan we want to use.
          On anything other than a Thinkpad you'll probably
          use some PWM control file in /sys/class/hwmon.
          A sysfs fan would be specified like this:
            pwm_fan /sys/class/hwmon/hwmon2/device/pwm1
        '';
      };

      levels = mkOption {
        type = types.lines;
        default = ''
          (0,     0,      55)
          (1,     48,     60)
          (2,     50,     61)
          (3,     52,     63)
          (6,     56,     65)
          (7,     60,     85)
          (127,   80,     32767)
        '';
        description = ''
          (LEVEL, LOW, HIGH)
          LEVEL is the fan level to use (0-7 with thinkpad_acpi).
          LOW is the temperature at which to step down to the previous level.
          HIGH is the temperature at which to step up to the next level.
          All numbers are integers.
        '';
      };


    };

  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ thinkfan ];

    systemd.services.thinkfan = {
      description = "Thinkfan";
      after = [ "basic.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ thinkfan ];
      serviceConfig.ExecStart = "${thinkfan}/bin/thinkfan -n -c ${configFile}";
    };

    boot.extraModprobeConfig = "options thinkpad_acpi experimental=1 fan_control=1";

  };
}
