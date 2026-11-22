{ lib, ... }:

{
  imports = [ ./installation-cd-minimal.nix ];

  isoImage.configurationName = lib.mkDefault "(Linux LTS)";

  specialisation.latest_kernel.configuration =
    { config, ... }:
    {
      imports = [ ./latest-kernel.nix ];
      isoImage.configurationName = "(Linux ${config.boot.kernelPackages.kernel.version})";
    };
}
