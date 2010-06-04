{ config, pkgs, ... }:

with pkgs.lib;

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
            description = "Path of the device.";
          };

          label = mkOption {
            example = "swap";
            type = types.string;
            description = ''
              Label of the device.  Can be used instead of <varname>device</varname>.
            '';
          };

          cipher = mkOption {
            default = false;
            example = true;
            type = types.bool;
            description = ''
              Encrypt the swap device to protect swapped data.  This option
              does not work with labels.
            '';
          };

        };

        config = {
          device =
            if options.label.isDefined then
              "/dev/disk/by-label/${config.label}"
            else
              mkNotdef;
        };
        
      };
      
    };

  };

}
