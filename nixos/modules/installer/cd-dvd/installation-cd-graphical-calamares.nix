# This module adds the calamares installer to the basic graphical NixOS
# installation CD.

{ pkgs, ... }:
let
  calamares-nixos-autostart = pkgs.makeAutostartItem {
    name = "io.calamares.calamares";
    package = pkgs.calamares-nixos;
  };
in
{
  imports = [ ./installation-cd-graphical-base.nix ];

  environment.systemPackages = with pkgs; [
    # Calamares for graphical installation
    libsForQt5.kpmcore
    calamares-nixos
    calamares-nixos-autostart
    calamares-nixos-extensions
    # Get list of locales
    glibcLocales
  ];

  # Support choosing from any locale
  i18n.supportedLocales = [ "all" ];
}
