{ lib }:

{
  options = {

    addr = lib.mkOption {
      type = lib.types.str;
      description = ''
        IP address, lib.optionally with a netmask: IPADDR[/MASK]
      '';
    };

    brd = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        The broadcast address on the interface.
      '';
    };

    dev = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        The name of the device to add the address to.
      '';
    };

    scope = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        The scope of the area where this address is valid.
      '';
    };

    label = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Each address may be tagged with a label string. In order to preserve
        compatibility with Linux-2.0 net aliases, this string must coincide with
        the name of the device or must be prefixed with the device name followed
        by colon.
      '';
    };

  };
}
