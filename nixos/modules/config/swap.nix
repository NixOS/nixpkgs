{ config, pkgs, utils, ... }:

with pkgs.lib;
with utils;

{

  ###### interface

  options = {

    swapDevices = mkOption {
      default = [];
      example = [
        { device = "/dev/hda7"; }
        { device = "/var/swapfile"; }
        { label = "bigswap"; }
      ];
      description = ''
        The swap devices and swap files.  These must have been
        initialised using <command>mkswap</command>.  Each element
        should be an attribute set specifying either the path of the
        swap device or file (<literal>device</literal>) or the label
        of the swap device (<literal>label</literal>, see
        <command>mkswap -L</command>).  Using a label is
        recommended.
      '';

      type = types.listOf types.optionSet;

      options = {config, options, ...}: {

        options = {

          device = mkOption {
            example = "/dev/sda3";
            type = types.str;
            description = "Path of the device.";
          };

          label = mkOption {
            example = "swap";
            type = types.str;
            description = ''
              Label of the device.  Can be used instead of <varname>device</varname>.
            '';
          };

          size = mkOption {
            default = null;
            example = 2048;
            type = types.nullOr types.int;
            description = ''
              If this option is set, ‘device’ is interpreted as the
              path of a swapfile that will be created automatically
              with the indicated size (in megabytes) if it doesn't
              exist.
            '';
          };

          priority = mkOption {
            default = null;
            example = 2048;
            type = types.nullOr types.int;
            description = ''
              Specify the priority of the swap device. Priority is a value between 0 and 32767.
              Higher numbers indicate higher priority.
              null lets the kernel choose a priority, which will show up as a negative value.
            '';
          };

        };

        config = {
          device = mkIf options.label.isDefined
            "/dev/disk/by-label/${config.label}";
        };

      };

    };

  };

  config = mkIf ((length config.swapDevices) != 0) {

    system.requiredKernelConfig = with config.lib.kernelConfig; [
      (isYes "SWAP")
    ];

    # Create missing swapfiles.
    # FIXME: support changing the size of existing swapfiles.
    systemd.services =
      let

        createSwapDevice = sw:
          assert sw.device != "";
          let device' = escapeSystemdPath sw.device; in
          nameValuePair "mkswap-${escapeSystemdPath sw.device}"
          { description = "Initialisation of Swapfile ${sw.device}";
            wantedBy = [ "${device'}.swap" ];
            before = [ "${device'}.swap" ];
            path = [ pkgs.utillinux ];
            script =
              ''
                if [ ! -e "${sw.device}" ]; then
                  fallocate -l ${toString sw.size}M "${sw.device}" ||
                    dd if=/dev/zero of="${sw.device}" bs=1M count=${toString sw.size}
                  mkswap ${sw.device}
                fi
              '';
            unitConfig.RequiresMountsFor = [ "${dirOf sw.device}" ];
            unitConfig.DefaultDependencies = false; # needed to prevent a cycle
            serviceConfig.Type = "oneshot";
          };

      in listToAttrs (map createSwapDevice (filter (sw: sw.size != null) config.swapDevices));

  };

}
