{pkgs, config, ...}:

let
  inherit (config.boot) kernelPackages;
in

# !!! make this optional

{
  boot = {
    extraModulePackages =
      pkgs.lib.optional
        (!kernelPackages.kernel.features ? iwlwifi)
        kernelPackages.iwlwifi;
  };

  services = {
    udev = {
      addFirmware = [ pkgs.iwlwifi3945ucode ];
    };
  };
}
