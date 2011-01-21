# This module defines a NixOS installation CD that contains X11 and
# KDE 4.

{ config, pkgs, ... }:

{
  require = [
    ./installation-cd-base.nix
    ../../profiles/graphical.nix
  ];

  # Disable compositing for now.  It seems to cause problems with KDE
  # 4.5 on some graphics drivers (such as Cirrus and VGA in QEMU).
  services.xserver.config =
    ''
      Section "Extensions"
        Option "Composite" "Disable"
      EndSection
    '';
}
