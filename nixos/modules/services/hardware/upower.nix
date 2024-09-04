# Upower daemon.
{ config, lib, pkgs, ... }:
let

  cfg = config.services.upower;

in

{

  ###### interface

  options = {

    services.upower = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable Upower, a DBus service that provides power
          management support to applications.
        '';
      };

      package = lib.mkPackageOption pkgs "upower" { };

      enableWattsUpPro = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable the Watts Up Pro device.

          The Watts Up Pro contains a generic FTDI USB device without a specific
          vendor and product ID. When we probe for WUP devices, we can cause
          the user to get a perplexing "Device or resource busy" error when
          attempting to use their non-WUP device.

          The generic FTDI device is known to also be used on:

          - Sparkfun FT232 breakout board
          - Parallax Propeller
        '';
      };

      noPollBatteries = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Don't poll the kernel for battery level changes.

          Some hardware will send us battery level changes through
          events, rather than us having to poll for it. This option
          allows disabling polling for hardware that sends out events.
        '';
      };

      ignoreLid = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Do we ignore the lid state

          Some laptops are broken. The lid state is either inverted, or stuck
          on or off. We can't do much to fix these problems, but this is a way
          for users to make the laptop panel vanish, a state that might be used
          by a couple of user-space daemons. On Linux systems, see also
          logind.conf(5).
        '';
      };

      usePercentageForPolicy = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Policy for warnings and action based on battery levels

          Whether battery percentage based policy should be used. The default
          is to use the percentage, which
          should work around broken firmwares. It is also more reliable than
          the time left (frantically saving all your files is going to use more
          battery than letting it rest for example).
        '';
      };

      percentageLow = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 10;
        description = ''
          When `usePercentageForPolicy` is
          `true`, the levels at which UPower will consider the
          battery low.

          This will also be used for batteries which don't have time information
          such as that of peripherals.

          If any value (of `percentageLow`,
          `percentageCritical` and
          `percentageAction`) is invalid, or not in descending
          order, the defaults will be used.
        '';
      };

      percentageCritical = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 3;
        description = ''
          When `usePercentageForPolicy` is
          `true`, the levels at which UPower will consider the
          battery critical.

          This will also be used for batteries which don't have time information
          such as that of peripherals.

          If any value (of `percentageLow`,
          `percentageCritical` and
          `percentageAction`) is invalid, or not in descending
          order, the defaults will be used.
        '';
      };

      percentageAction = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 2;
        description = ''
          When `usePercentageForPolicy` is
          `true`, the levels at which UPower will take action
          for the critical battery level.

          This will also be used for batteries which don't have time information
          such as that of peripherals.

          If any value (of `percentageLow`,
          `percentageCritical` and
          `percentageAction`) is invalid, or not in descending
          order, the defaults will be used.
        '';
      };

      timeLow = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 1200;
        description = ''
          When `usePercentageForPolicy` is
          `false`, the time remaining in seconds at which
          UPower will consider the battery low.

          If any value (of `timeLow`,
          `timeCritical` and `timeAction`) is
          invalid, or not in descending order, the defaults will be used.
        '';
      };

      timeCritical = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 300;
        description = ''
          When `usePercentageForPolicy` is
          `false`, the time remaining in seconds at which
          UPower will consider the battery critical.

          If any value (of `timeLow`,
          `timeCritical` and `timeAction`) is
          invalid, or not in descending order, the defaults will be used.
        '';
      };

      timeAction = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 120;
        description = ''
          When `usePercentageForPolicy` is
          `false`, the time remaining in seconds at which
          UPower will take action for the critical battery level.

          If any value (of `timeLow`,
          `timeCritical` and `timeAction`) is
          invalid, or not in descending order, the defaults will be used.
        '';
      };

      criticalPowerAction = lib.mkOption {
        type = lib.types.enum [ "PowerOff" "Hibernate" "HybridSleep" ];
        default = "HybridSleep";
        description = ''
          The action to take when `timeAction` or
          `percentageAction` has been reached for the batteries
          (UPS or laptop batteries) supplying the computer
        '';
      };

    };

  };


  ###### implementation

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    services.udev.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    environment.etc."UPower/UPower.conf".text = lib.generators.toINI {} {
      UPower = {
        EnableWattsUpPro = cfg.enableWattsUpPro;
        NoPollBatteries = cfg.noPollBatteries;
        IgnoreLid = cfg.ignoreLid;
        UsePercentageForPolicy = cfg.usePercentageForPolicy;
        PercentageLow = cfg.percentageLow;
        PercentageCritical = cfg.percentageCritical;
        PercentageAction = cfg.percentageAction;
        TimeLow = cfg.timeLow;
        TimeCritical = cfg.timeCritical;
        TimeAction = cfg.timeAction;
        CriticalPowerAction = cfg.criticalPowerAction;
      };
    };
  };

}
