# This module defines a NixOS installation CD that contains Plasma 6.

{ lib, pkgs, ... }:

{
  imports = [ ./installation-cd-graphical-calamares.nix ];

  isoImage.edition = lib.mkDefault "plasma6";

  services.desktopManager.plasma6.enable = true;

  # Automatically login as nixos.
  services.displayManager = {
    plasma-login-manager.enable = true;
    autoLogin = {
      enable = true;
      user = "nixos";
    };
  };

  environment.systemPackages = [
    # provide onscreen keyboard
    pkgs.kdePackages.plasma-keyboard
  ];

  environment.plasma6.excludePackages = [
    # Optional wallpapers that add 126 MiB to the graphical installer
    # closure. They will still need to be downloaded when installing a
    # Plasma system, though.
    pkgs.kdePackages.plasma-workspace-wallpapers
  ];

  # Avoid bundling an entire MariaDB installation on the ISO.
  programs.kde-pim.enable = false;

  system.activationScripts.installerDesktop =
    let

      # Comes from documentation.nix when xserver and nixos.enable are true.
      manualDesktopFile = "/run/current-system/sw/share/applications/nixos-manual.desktop";

      homeDir = "/home/nixos/";
      desktopDir = homeDir + "Desktop/";

    in
    ''
      mkdir -p ${desktopDir}
      chown nixos ${homeDir} ${desktopDir}

      ln -sfT ${manualDesktopFile} ${desktopDir + "nixos-manual.desktop"}
      ln -sfT ${pkgs.gparted}/share/applications/gparted.desktop ${desktopDir + "gparted.desktop"}
      ln -sfT ${pkgs.calamares-nixos}/share/applications/calamares.desktop ${
        desktopDir + "calamares.desktop"
      }
    '';

  # Auto-login leaves pam_kwallet with no password to unlock the wallet,
  # so plasma-nm blocks indefinitely when saving Wi-Fi PSKs via Secret
  # Service and the installer GUI hangs on "waiting for authorization".
  # The live session has no secrets worth persisting.
  # https://github.com/NixOS/nixpkgs/issues/219346
  environment.etc."xdg/kwalletrc".text = ''
    [Wallet]
    Enabled=false
  '';

}
