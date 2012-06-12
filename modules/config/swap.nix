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
            type = types.uniq types.string;
            description = "Path of the device.";
          };

          label = mkOption {
            example = "swap";
            type = types.uniq types.string;
            description = ''
              Label of the device.  Can be used instead of <varname>device</varname>.
            '';
          };

          size = mkOption {
            default = null;
            example = "swap";
            type = types.nullOr types.int;
            description = ''
              Label of the device.  Can be used instead of <varname>device</varname>.
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
