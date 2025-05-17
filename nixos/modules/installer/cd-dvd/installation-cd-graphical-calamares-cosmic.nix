# This module defines a NixOS installation CD that contains Plasma 6.

{ lib, pkgs, ... }:

let
  guiprintenv = pkgs.python3Packages.buildPythonPackage rec {
    name = "guiprintenv";
    format = "other";

    dontUnpack = true;
    src = "${pkgs.writeText "main.py" ''
      import os
      from tkinter import *

      root = Tk()
      text = Text(root)
      text.insert(END, '\n'.join(f'{k}={v}' for k, v in os.environ.items()))
      text.pack()
      root.mainloop()
    ''}";

    nativeBuildInputs = [ pkgs.makeWrapper ];
    propagatedBuildInputs = with pkgs; [
      python3Packages.tkinter
      python3
      tk
    ];

    installPhase = ''
      mkdir -p $out/bin
      cp ${src} $out/bin/guiprintenv
      chmod +x $out/bin/guiprintenv

      mkdir -p $out/share/applications
      cp "${pkgs.writeText "guiprintenv.desktop" ''
        [Desktop Entry]
        Type=Application
        Nameguiprintenv
        Path=${placeholder "out"}/bin
        Exec=guiprintenv
        Terminal=false
      ''}" $out/share/applications/guiprintenv.desktop
    '';

    postFixup = ''
      sed -i '1i#!/usr/bin/env python3' $out/bin/guiprintenv
      wrapProgram $out/bin/guiprintenv \
        --set PYTHONPATH "${pkgs.python3.pkgs.tkinter}/${pkgs.python3.sitePackages}:$PYTHONPATH"
    '';
  };
in

{
  imports = [ ./installation-cd-graphical-calamares.nix ];

  isoImage.edition = lib.mkDefault "cosmic";

  services = {
    desktopManager.cosmic.enable = true;
    displayManager = {
      cosmic-greeter.enable = true;

      # No need to have a lockscreen on an installer ISO, enable autologin
      autoLogin = {
        enable = true;
        user = "nixos";
      };

    };
  };

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
      cp ${guiprintenv}/share/applications/guiprintenv.desktop /home/nixos/

      mkdir -p /home/nixos/.config/autostart
      cp ${guiprintenv}/share/applications/guiprintenv.desktop /home/nixos/.config/autostart/guiprintenv.desktop
      cp "${pkgs.writeText "guiprintenv.sh" ''${guiprintenv}/bin/guiprintenv''}" /home/nixos/guiprintenv.sh
      chmod +x /home/nixos/guiprintenv.sh

      ln -sfT ${manualDesktopFile} ${desktopDir + "nixos-manual.desktop"}
      ln -sfT ${pkgs.gparted}/share/applications/gparted.desktop ${desktopDir + "gparted.desktop"}
      ln -sfT ${pkgs.calamares-nixos}/share/applications/io.calamares.calamares.desktop ${
        desktopDir + "io.calamares.calamares.desktop"
      }
    '';

}
