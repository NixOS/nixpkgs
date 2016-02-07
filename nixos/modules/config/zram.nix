{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.zramSwap;

  devices = map (nr: "zram${toString nr}") (range 0 (cfg.numDevices - 1));

  modprobe = "${config.system.sbin.modprobe}/sbin/modprobe";

in

{

  ###### interface

  options = {

    zramSwap = {

      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable in-memory compressed swap space provided by the zram kernel
          module. It is recommended to enable only for kernel 3.14 or higher.
        '';
      };

      numDevices = mkOption {
        default = 4;
        type = types.int;
        description = ''
          Number of zram swap devices to create. It should be equal to the
          number of CPU cores your system has.
        '';
      };

      memoryPercent = mkOption {
        default = 50;
        type = types.int;
        description = ''
          Maximum amount of memory that can be used by the zram swap devices
          (as a percentage of your total memory). Defaults to 1/2 of your total
          RAM.
        '';
      };

      priority = mkOption {
        default = 5;
        type = types.int;
        description = ''
          Priority of the zram swap devices. It should be a number higher than
          the priority of your disk-based swap devices (so that the system will
          fill the zram swap devices before falling back to disk swap).
        '';
      };

    };

  };

  config = mkIf cfg.enable {

    system.requiredKernelConfig = with config.lib.kernelConfig; [
      (isModule "ZRAM")
    ];

    # Disabling this for the moment, as it would create and mkswap devices twice,
    # once in stage 2 boot, and again when the zram-reloader service starts.
    # boot.kernelModules = [ "zram" ];

    boot.extraModprobeConfig = ''
      options zram num_devices=${toString cfg.numDevices}
    '';

    services.udev.extraRules = ''
      KERNEL=="zram[0-9]*", ENV{SYSTEMD_WANTS}="zram-init-%k.service", TAG+="systemd"
    '';

    systemd.services =
      let
        createZramInitService = dev:
          nameValuePair "zram-init-${dev}" {
            description = "Init swap on zram-based device ${dev}";
            bindsTo = [ "dev-${dev}.swap" ];
            after = [ "dev-${dev}.device" "zram-reloader.service" ];
            requires = [ "dev-${dev}.device" "zram-reloader.service" ];
            before = [ "dev-${dev}.swap" ];
            requiredBy = [ "dev-${dev}.swap" ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStop = "${pkgs.stdenv.shell} -c 'echo 1 > /sys/class/block/${dev}/reset'";
            };
            script = ''
              set -u
              set -o pipefail
              
              # Calculate memory to use for zram
              totalmem=$(${pkgs.gnugrep}/bin/grep 'MemTotal: ' /proc/meminfo | ${pkgs.gawk}/bin/awk '{print $2}')
              mem=$(((totalmem * ${toString cfg.memoryPercent} / 100 / ${toString cfg.numDevices}) * 1024))

              echo $mem > /sys/class/block/${dev}/disksize
              ${pkgs.utillinux}/sbin/mkswap /dev/${dev}
            '';
            restartIfChanged = false;
          };
      in listToAttrs ((map createZramInitService devices) ++ [(nameValuePair "zram-reloader"
        {
          description = "Reload zram kernel module when number of devices changes";
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStartPre = "${modprobe} -r zram";
            ExecStart = "${modprobe} zram";
            ExecStop = "${modprobe} -r zram";
          };
          restartTriggers = [ cfg.numDevices ];
          restartIfChanged = true;
        })]);

    swapDevices =
      let
        useZramSwap = dev:
          {
            device = "/dev/${dev}";
            priority = cfg.priority;
          };
      in map useZramSwap devices;

  };

}
