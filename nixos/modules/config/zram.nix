{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.zramSwap;

  # don't set swapDevices as mkDefault, so we can detect user had read our warning
  # (see below) and made an action (or not)
  devicesCount = if cfg.swapDevices != null then cfg.swapDevices else cfg.numDevices;

  devices = map (nr: "zram${toString nr}") (range 0 (devicesCount - 1));

  modprobe = "${pkgs.kmod}/bin/modprobe";

  warnings =
  assert cfg.swapDevices != null -> cfg.numDevices >= cfg.swapDevices;
  flatten [
    (optional (cfg.numDevices > 1 && cfg.swapDevices == null) ''
      Using several small zram devices as swap is no better than using one large.
      Set either zramSwap.numDevices = 1 or explicitly set zramSwap.swapDevices.

      Previously multiple zram devices were used to enable multithreaded
      compression. Linux supports multithreaded compression for 1 device
      since 3.15. See https://lkml.org/lkml/2014/2/28/404 for details.
    '')
  ];

in

{

  ###### interface

  options = {

    zramSwap = {

      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable in-memory compressed devices and swap space provided by the zram
          kernel module.
          See <link xlink:href="https://www.kernel.org/doc/Documentation/blockdev/zram.txt">
            https://www.kernel.org/doc/Documentation/blockdev/zram.txt
          </link>.
        '';
      };

      numDevices = mkOption {
        default = 1;
        type = types.int;
        description = ''
          Number of zram devices to create. See also
          <literal>zramSwap.swapDevices</literal>
        '';
      };

      swapDevices = mkOption {
        default = null;
        example = 1;
        type = with types; nullOr int;
        description = ''
          Number of zram devices to be used as swap. Must be
          <literal>&lt;= zramSwap.numDevices</literal>.
          Default is same as <literal>zramSwap.numDevices</literal>, recommended is 1.
        '';
      };

      memoryPercent = mkOption {
        default = 50;
        type = types.int;
        description = ''
          Maximum amount of memory that can be used by the zram swap devices
          (as a percentage of your total memory). Defaults to 1/2 of your total
          RAM. Run <literal>zramctl</literal> to check how good memory is
          compressed.
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

      algorithm = mkOption {
        default = "zstd";
        example = "lz4";
        type = with types; either (enum [ "lzo" "lz4" "zstd" ]) str;
        description = ''
          Compression algorithm. <literal>lzo</literal> has good compression,
          but is slow. <literal>lz4</literal> has bad compression, but is fast.
          <literal>zstd</literal> is both good compression and fast, but requires newer kernel.
          You can check what other algorithms are supported by your zram device with
          <programlisting>cat /sys/class/block/zram*/comp_algorithm</programlisting>
        '';
      };
    };

  };

  config = mkIf cfg.enable {

    inherit warnings;

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
            after = [ "dev-${dev}.device" "zram-reloader.service" ];
            requires = [ "dev-${dev}.device" "zram-reloader.service" ];
            before = [ "dev-${dev}.swap" ];
            requiredBy = [ "dev-${dev}.swap" ];
            unitConfig.DefaultDependencies = false; # needed to prevent a cycle
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStop = "${pkgs.runtimeShell} -c 'echo 1 > /sys/class/block/${dev}/reset'";
            };
            script = ''
              set -euo pipefail

              # Calculate memory to use for zram
              mem=$(${pkgs.gawk}/bin/awk '/MemTotal: / {
                  print int($2*${toString cfg.memoryPercent}/100.0/${toString devicesCount}*1024)
              }' /proc/meminfo)

              ${pkgs.utillinux}/sbin/zramctl --size $mem --algorithm ${cfg.algorithm} /dev/${dev}
              ${pkgs.utillinux}/sbin/mkswap /dev/${dev}
            '';
            restartIfChanged = false;
          };
      in listToAttrs ((map createZramInitService devices) ++ [(nameValuePair "zram-reloader"
        {
          description = "Reload zram kernel module when number of devices changes";
          wants = [ "systemd-udevd.service" ];
          after = [ "systemd-udevd.service" ];
          unitConfig.DefaultDependencies = false; # needed to prevent a cycle
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStartPre = "${modprobe} -r zram";
            ExecStart = "${modprobe} zram";
            ExecStop = "${modprobe} -r zram";
          };
          restartTriggers = [
            cfg.numDevices
            cfg.algorithm
            cfg.memoryPercent
          ];
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
