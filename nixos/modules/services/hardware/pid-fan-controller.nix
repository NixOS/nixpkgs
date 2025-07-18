{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.pid-fan-controller;
  heatSource = {
    options = {
      name = lib.mkOption {
        type = lib.types.uniq lib.types.nonEmptyStr;
        description = "Name of the heat source.";
      };
      wildcardPath = lib.mkOption {
        type = lib.types.nonEmptyStr;
        description = ''
          Path of the heat source's `hwmon` `temp_input` file.
          This path can contain multiple wildcards, but has to resolve to
          exactly one result.
        '';
      };
      pidParams = {
        setPoint = lib.mkOption {
          type = lib.types.ints.unsigned;
          description = "Set point of the controller in °C.";
        };
        P = lib.mkOption {
          description = "K_p of PID controller.";
          type = lib.types.float;
        };
        I = lib.mkOption {
          description = "K_i of PID controller.";
          type = lib.types.float;
        };
        D = lib.mkOption {
          description = "K_d of PID controller.";
          type = lib.types.float;
        };
      };
    };
  };

  fan = {
    options = {
      wildcardPath = lib.mkOption {
        type = lib.types.str;
        description = ''
          Wildcard path of the `hwmon` `pwm` file.
          If the fans are not to be found in `/sys/class/hwmon/hwmon*` the corresponding
          kernel module (like `nct6775`) needs to be added to `boot.kernelModules`.
          See the [`hwmon` Documentation](https://www.kernel.org/doc/html/latest/hwmon/index.html).
        '';
      };
      minPwm = lib.mkOption {
        default = 0;
        type = lib.types.ints.u8;
        description = "Minimum PWM value.";
      };
      maxPwm = lib.mkOption {
        default = 255;
        type = lib.types.ints.u8;
        description = "Maximum PWM value.";
      };
      cutoff = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to stop the fan when `minPwm` is reached.";
      };
      heatPressureSrcs = lib.mkOption {
        type = lib.types.nonEmptyListOf lib.types.str;
        description = "Heat pressure sources affected by the fan.";
      };
    };
  };
in
{
  options.services.pid-fan-controller = {
    enable = lib.mkEnableOption "the PID fan controller, which controls the configured fans by running a closed-loop PID control loop";
    package = lib.mkPackageOption pkgs "pid-fan-controller" { };
    settings = {
      interval = lib.mkOption {
        default = 500;
        type = lib.types.int;
        description = "Interval between controller cycles in milliseconds.";
      };
      heatSources = lib.mkOption {
        type = lib.types.listOf (lib.types.submodule heatSource);
        description = "List of heat sources to be monitored.";
        example = ''
          [
            {
              name = "cpu";
              wildcardPath = "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon*/temp1_input";
              pidParams = {
                setPoint = 60;
                P = -5.0e-3;
                I = -2.0e-3;
                D = -6.0e-3;
              };
            }
          ];
        '';
      };
      fans = lib.mkOption {
        type = lib.types.listOf (lib.types.submodule fan);
        description = "List of fans to be controlled.";
        example = ''
          [
            {
              wildcardPath = "/sys/devices/platform/nct6775.2592/hwmon/hwmon*/pwm1";
              minPwm = 60;
              maxPwm = 255;
              heatPressureSrcs = [
                "cpu"
                "gpu"
              ];
            }
          ];
        '';
      };
    };
  };
  config = lib.mkIf cfg.enable {
    #map camel cased attrs into snake case for config
    environment.etc."pid-fan-settings.json".text = builtins.toJSON {
      interval = cfg.settings.interval;
      heat_srcs = map (heatSrc: {
        name = heatSrc.name;
        wildcard_path = heatSrc.wildcardPath;
        PID_params = {
          set_point = heatSrc.pidParams.setPoint;
          P = heatSrc.pidParams.P;
          I = heatSrc.pidParams.I;
          D = heatSrc.pidParams.D;
        };
      }) cfg.settings.heatSources;
      fans = map (fan: {
        wildcard_path = fan.wildcardPath;
        min_pwm = fan.minPwm;
        max_pwm = fan.maxPwm;
        cutoff = fan.cutoff;
        heat_pressure_srcs = fan.heatPressureSrcs;
      }) cfg.settings.fans;
    };

    systemd.services.pid-fan-controller = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = [ (lib.getExe cfg.package) ];
        ExecStopPost = [ "${lib.getExe cfg.package} disable" ];
        Restart = "always";
        #This service needs to run as root to write to /sys.
        #therefore it should operate with the least amount of privileges needed
        ProtectHome = "yes";
        #strict is not possible as it needs /sys
        ProtectSystem = "full";
        ProtectProc = "invisible";
        PrivateNetwork = "yes";
        NoNewPrivileges = "yes";
        MemoryDenyWriteExecute = "yes";
        RestrictNamespaces = "~user pid net uts mnt";
        ProtectKernelModules = "yes";
        RestrictRealtime = "yes";
        SystemCallFilter = "@system-service";
        CapabilityBoundingSet = "~CAP_KILL CAP_WAKE_ALARM CAP_IPC_LOC CAP_BPF CAP_LINUX_IMMUTABLE CAP_BLOCK_SUSPEND CAP_MKNOD";
      };
      # restart unit if config changed
      restartTriggers = [ config.environment.etc."pid-fan-settings.json".source ];
    };
    #sleep hook to restart the service as it breaks otherwise
    systemd.services.pid-fan-controller-sleep = {
      before = [ "sleep.target" ];
      wantedBy = [ "sleep.target" ];
      unitConfig = {
        StopWhenUnneeded = "yes";
      };
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = [ "systemctl stop pid-fan-controller.service" ];
        ExecStop = [ "systemctl restart pid-fan-controller.service" ];
      };
    };
  };
  meta.maintainers = with lib.maintainers; [ zimward ];
}
