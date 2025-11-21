{ config, lib, ... }:
let
  # Filter network interfaces from facter report to only those suitable for DHCP
  physicalInterfaces = lib.filter (
    iface:
    # Only include network interfaces suitable for DHCP:
    # - Ethernet (most common)
    # - WLAN (WiFi)
    # - USB-Link (USB network adapters, tethering)
    # - Network Interface (generic/unknown type)
    # This implicitly excludes: Loopback, mainframe-specific interfaces (CTC, IUCV, HSI, ESCON)
    # See: https://github.com/numtide/hwinfo/blob/ea251a74b88dcd53aebdd381194ab43d10fbbd79/src/ids/src/class#L817-L874
    let
      validTypes = [
        "Ethernet"
        "WLAN"
        "USB-Link"
        "Network Interface"
      ];
    in
    lib.elem (iface.sub_class.name or "") validTypes
  ) (config.hardware.facter.report.hardware.network_interface or [ ]);

  # Extract interface names from unix_device_names
  detectedInterfaceNames = lib.concatMap (iface: iface.unix_device_names or [ ]) physicalInterfaces;

  # Get the interface names from the configuration (which defaults to detectedInterfaceNames)
  interfaceNames = config.hardware.facter.detected.dhcp.interfaces;

  # Generate per-interface DHCP config
  perInterfaceConfig = lib.listToAttrs (
    lib.map (name: {
      inherit name;
      value = {
        useDHCP = lib.mkDefault true;
      };
    }) interfaceNames
  );
in
{
  imports = [
    ./initrd.nix
    ./intel.nix
  ];

  options.hardware.facter.detected.dhcp = {
    enable = lib.mkEnableOption "Facter dhcp module" // {
      default = builtins.length config.hardware.facter.report.hardware.network_interface or [ ] > 0;
      defaultText = "hardware dependent";
    };

    interfaces = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = detectedInterfaceNames;
      defaultText = lib.literalExpression "automatically detected from facter report";
      description = "List of network interface names to configure with DHCP. Defaults to auto-detected physical interfaces.";
      example = [
        "eth0"
        "wlan0"
      ];
    };
  };
  config =
    lib.mkIf (config.hardware.facter.reportPath != null && config.hardware.facter.detected.dhcp.enable)
      {
        networking.useDHCP = lib.mkDefault true;

        # Per-interface DHCP configuration
        networking.interfaces = perInterfaceConfig;
      };
}
