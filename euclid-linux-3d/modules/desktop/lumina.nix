{ config, pkgs, lib, ... }: {
  services.xserver.desktopManager.lumina.enable = true;

  services.displayManager.sessionPackages = [
    (pkgs.stdenv.mkDerivation {
      name = "euclid-lumina-3d-session";
      src = pkgs.writeTextFile {
        name = "euclid-lumina-3d.desktop";
        destination = "/share/xsessions/euclid-lumina-3d.desktop";
        text = ''
          [Desktop Entry]
          Name=Euclid Lumina 3D
          Comment=This session logs you into Lumina with Compiz
          Exec=env STARTUP_WM=compiz lumina-desktop
          TryExec=lumina-desktop
          Icon=
          Type=Application
          DesktopNames=Lumina
        '';
      };
      passthru.providedSessions = [ "euclid-lumina-3d" ];
      phases = [ "installPhase" ];
      installPhase = ''
        mkdir -p $out/share/xsessions
        cp $src/share/xsessions/euclid-lumina-3d.desktop $out/share/xsessions/
      '';
    })
  ];
}
