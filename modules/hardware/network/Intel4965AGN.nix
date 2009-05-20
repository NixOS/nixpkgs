{pkgs, config, ...}:

let
  inherit (config.boot) kernelPackages;
  inherit (kernelPackages) kernel;
in

{
  boot = {
    extraModulePackages =
      pkgs.lib.optional
        (!kernel.features ? iwlwifi)
        kernelPackages.iwlwifi;
  };

  services = {
    udev = {
      addFirmware = [ pkgs.iwlwifi4965ucode ];
    };
  };
}
