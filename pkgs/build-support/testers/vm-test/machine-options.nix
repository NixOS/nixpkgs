{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption types literalExpression;
in
{
  options = {
    name = mkOption {
      description = "The attribute name this machine was declared under.";
      type = types.str;
      readOnly = true;
    };

    image = mkOption {
      description = ''
        The disk image to boot.

        A package or path whose output is a qcow2 image.
      '';
      type = types.either types.package types.path;
      example = literalExpression "pkgs.arch-cloud-image";
    };

    cpus = mkOption {
      description = "Number of virtual CPUs.";
      type = types.ints.positive;
      default = 2;
    };

    memory = mkOption {
      description = "Guest memory, in the format qemu accepts (`2G`, `1024`).";
      type = types.either types.ints.positive types.str;
      default = "2G";
    };

    boot = mkOption {
      description = "Whether to boot via EFI or the MBR.";
      type = types.enum [
        "efi"
        "mbr"
      ];
      default = "efi";
    };

    snapshot = mkOption {
      description = ''
        Discard the guest's writes instead of storing them back into the image.

        This is necessary for any image coming from the store as the file is
        read-only.

        Turn it off only for an image you wrote outside the store and intend to
        mutate.
      '';
      type = types.bool;
      default = true;
    };

    networking = mkOption {
      description = ''
        Whether to give the guest a network device.

        Off by default: commands go over vsock, so most tests do not need a
        network.
      '';
      type = types.bool;
      default = false;
    };

    credentials = mkOption {
      description = ''
        systemd credentials to hand the guest through SMBIOS OEM strings.

        The guest sees these in its DMI tables, which systemd turns into
        `LoadCredential=`-style credentials.

        See
        https://www.freedesktop.org/software/systemd/man/latest/systemd.system-credentials.html
        for standard examples.
      '';
      type = types.attrsOf types.str;
      default = { };
      example = literalExpression ''
        { "myapp.config" = "key=value"; }
      '';
    };

    cloudInit = mkOption {
      description = ''
        cloud-init user data as an escape hatch.

        Credentials are the better mechanism. Use this only when you need
        cloud-init itself to act (growing a partition, installing packages).
      '';
      type = types.nullOr (types.attrsOf types.raw);
      default = null;
    };

    bootTimeout = mkOption {
      description = "Seconds to wait for the guest to become reachable.";
      type = types.ints.positive;
      default = 120;
    };

    driverConfiguration = mkOption {
      internal = true;
      type = types.raw;
    };
  };

  config.driverConfiguration = {
    inherit (config) name;
    backend = "qemu";
    image = if builtins.isPath config.image then toString config.image else "${config.image}";
    inherit (config)
      cpus
      boot
      snapshot
      networking
      credentials
      cloudInit
      ;
    memory = toString config.memory;
    boot_timeout = config.bootTimeout;
  };
}
