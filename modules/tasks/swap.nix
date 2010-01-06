{ config, pkgs, ... }:

with pkgs.lib;

let

  inherit (pkgs) cryptsetup utillinux;

in

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

      type = types.list types.optionSet;

      options = {config, options, ...}: {

        options = {
          device = mkOption {
            example = "/dev/sda3";
            type = types.string;
            description = ''
              Path of the device.
            '';
          };

          label = mkOption {
            example = "swap";
            type = types.string;
            description = "
              Label of the device.  Can be used instead of <varname>device</varname>.
            ";
          };

          cipher = mkOption {
            default = false;
            example = true;
            type = types.bool;
            description = "
              Cipher the swap device to protect swapped data.  This option
              does not work with labels.
            ";
          };

          command = mkOption {
            description = "
              Command used to activate the swap device.
            ";
          };
        };

        config = {
          device =
            if options.label.isDefined then
              "/dev/disk/by-label/${config.label}"
            else
              mkNotdef;

          command = ''
            if test -e "${config.device}"; then
              ${if config.cipher then ''
                  plainDevice="${config.device}"
                  name="crypt$(echo "$plainDevice" | sed -e 's,/,.,g')"
                  device="/dev/mapper/$name"
                  if ! test -e "$device"; then
                    ${cryptsetup}/sbin/cryptsetup -c aes -s 128 -d /dev/urandom create "$name" "$plainDevice"
                    ${utillinux}/sbin/mkswap -f "$device" || true
                  fi
                ''
                else ''
                  device="${config.device}"
                ''
              }
              device=$(readlink -f "$device")
              # Add new swap devices.
              if echo $unused | grep -q "^$device\$"; then
                unused="$(echo $unused | grep -v "^$device\$")"
              else
                ${utillinux}/sbin/swapon "$device" || true
              fi
            fi
          '';
        };

      };
      
    };

  };

  ###### implementation

  config = {

    jobs.swap =
      { task = true;

        startOn = ["startup" "new-devices"];

        script =
          ''
            unused="$(sed '1d; s/ .*//' /proc/swaps)"

            ${toString (map (x: x.command) config.swapDevices)}

            # Remove remaining swap devices.
            test -n "$unused" && ${utillinux}/sbin/swapoff $unused || true
          '';
      };

  };

}
