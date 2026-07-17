# This configuration uses a specialisation for each desired boot
# configuration, and a common parent configuration for all of them
# that's hidden. This allows users to import this module alongside
# their own and get the full array of specialisations inheriting the
# users' settings.

{ lib, ... }:
{
  imports = [ ./installation-cd-base.nix ];
  isoImage.edition = "graphical";
  isoImage.showConfiguration = lib.mkDefault false;

  specialisation = {
    gnome.configuration =
      { config, ... }:
      {
        imports = [ ./installation-cd-graphical-calamares-gnome.nix ];
        isoImage.showConfiguration = true;
        isoImage.configurationName = "GNOME (Linux LTS)";
      };

    gnome_latest_kernel.configuration =
      { config, ... }:
      {
        imports = [
          ./installation-cd-graphical-calamares-gnome.nix
          ./latest-kernel.nix
        ];
        isoImage.showConfiguration = true;
        isoImage.configurationName = "GNOME (Linux ${config.boot.kernelPackages.kernel.version})";
      };

    plasma.configuration =
      { config, ... }:
      {
        imports = [ ./installation-cd-graphical-calamares-plasma6.nix ];
        isoImage.showConfiguration = true;
        isoImage.configurationName = "Plasma (Linux LTS)";
      };

    plasma_latest_kernel.configuration =
      { config, ... }:
      {
        imports = [
          ./installation-cd-graphical-calamares-plasma6.nix
          ./latest-kernel.nix
        ];
        isoImage.showConfiguration = true;
        isoImage.configurationName = "Plasma (Linux ${config.boot.kernelPackages.kernel.version})";
      };
  };
}
