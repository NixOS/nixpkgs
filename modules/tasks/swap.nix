{ config, pkgs, ... }:

with pkgs.lib;

let

  inherit (pkgs) utillinux;

  toPath = x: if x.device != null then x.device else "/dev/disk/by-label/${x.label}";
  
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

      options = {

        device = mkOption {
          default = null;
          example = "/dev/sda3";
          type = types.nullOr types.string;
          description = ''
            Path of the device.
          '';
        };

        label = mkOption {
          default = null;
          example = "swap";
          type = types.nullOr types.string;
          description = "
            Label of the device.  Can be used instead of <varname>device</varname>.
          ";
        };

      };
      
    };

  };
  

  ###### implementation

  config = {

    jobAttrs.swap =
      { task = true;
        
        startOn = ["startup" "new-devices"];

        script =
          ''        
            swapDevices=${toString (map toPath config.swapDevices)}
          
            for device in $swapDevices; do
                ${utillinux}/sbin/swapon "$device" || true
            done

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
