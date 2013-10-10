{ config, pkgs, ... }:

with pkgs.lib;

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
    # sensor /proc/acpi/ibm/thermal (0, 0, 10)
    # will add a fixed value of 10 °C the 3rd value read from that file. Check out
    # http://www.thinkwiki.org/wiki/Thermal_Sensors to find out how much you may
    # want to add to certain temperatures.
    
    #  Syntax:
    #  (LEVEL, LOW, HIGH)
    #  LEVEL is the fan level to use (0-7 with thinkpad_acpi)
    #  LOW is the temperature at which to step down to the previous level
    #  HIGH is the temperature at which to step up to the next level
    #  All numbers are integers.
    #

    sensor ${cfg.sensor} (0, 10, 15, 2, 10, 5, 0, 3, 0, 3)
    
    (0,     0,      55)
    (1,     48,     60)
    (2,     50,     61)
    (3,     52,     63)
    (6,     56,     65)
    (7,     60,     85)
    (127,   80,     32767)
  '';

in {

  options = {

    services.thinkfan = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to enable thinkfan, fan controller for ibm/lenovo thinkpads.
        '';
      };

      sensor = mkOption {
        default = "/proc/acpi/ibm/thermal";
        description =''
          Sensor used by thinkfan
        '';
      };

    };

  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.thinkfan ];

    systemd.services.thinkfan = {
      description = "Thinkfan";
      after = [ "basic.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.thinkfan ];
      serviceConfig.ExecStart = "${pkgs.thinkfan}/bin/thinkfan -n -c ${configFile}";
    };

    boot.extraModprobeConfig = "options thinkpad_acpi experimental=1 fan_control=1";

  };

}
