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
              Cipher the swap device to protect swapped data.
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
                # swap labels could be preserved by using --skip (PAGE_SIZE / key size)
                # The current settings won't work on system with a PAGE_SIZE != 4096.
                oldDevice="${config.device}"
                device="crypt$(echo "$oldDevice" | sed -e 's,/,.,')"
                ${cryptsetup}/sbin/cryptsetup --skip 16 -c blowfish -s 256 -d /dev/urandom create "$device" "$oldDevice"
                ${utillinux}/sbin/swapon "/dev/mapper/$newDevice" || true
              ''
              else ''
                device="${config.device}"
                ${utillinux}/sbin/swapon "${config.device}" || true
              ''}
              swapDevices="$swapDevices $device"
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
            ${toString (map (x: x.command) config.swapDevices)}

            # Remove swap devices not listed in swapDevices.
            for used in $(cat /proc/swaps | grep '^/' | sed 's/ .*//'); do
                found=
                for device in $swapDevices; do
                    device=$(readlink -f $device)
                    if test "$used" = "$device"; then found=1; fi
                done
                if test -z "$found"; then
                    ${utillinux}/sbin/swapoff "$used" || true
                fi
            done
          '';
      };

  };

}
