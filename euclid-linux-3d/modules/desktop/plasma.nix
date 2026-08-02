{ config, pkgs, lib, ... }: {
  services.desktopManager.plasma6.enable = true;
  services.xserver.enable = true;

  services.displayManager.sessionPackages = [
    (pkgs.stdenv.mkDerivation {
      name = "euclid-plasma-3d-session";
      src = pkgs.writeTextFile {
        name = "euclid-plasma-3d.desktop";
        destination = "/share/xsessions/euclid-plasma-3d.desktop";
        text = ''
          [Desktop Entry]
          Name=Euclid Plasma 3D - Experimental
          Comment=Plasma 6 with Compiz (Experimental)
          Exec=env KDEWM=compiz startplasma-x11
          TryExec=startplasma-x11
          Icon=
          Type=Application
          DesktopNames=KDE
        '';
      };
      passthru.providedSessions = [ "euclid-plasma-3d" ];
      phases = [ "installPhase" ];
      installPhase = ''
        mkdir -p $out/share/xsessions
        cp $src/share/xsessions/euclid-plasma-3d.desktop $out/share/xsessions/
      '';
    })
  ];
}
