{ config, pkgs, lib, ... }: {
  services.xserver.desktopManager.mate.enable = true;

  services.displayManager.sessionPackages = [
    (pkgs.stdenv.mkDerivation {
      name = "euclid-mate-3d-session";
      src = pkgs.writeTextFile {
        name = "euclid-mate-3d.desktop";
        destination = "/share/xsessions/euclid-mate-3d.desktop";
        text = ''
          [Desktop Entry]
          Name=Euclid MATE 3D
          Comment=This session logs you into MATE with Compiz
          Exec=env MATE_WINDOW_MANAGER=compiz mate-session
          TryExec=mate-session
          Icon=
          Type=Application
          DesktopNames=MATE
        '';
      };
      passthru.providedSessions = [ "euclid-mate-3d" ];
      phases = [ "installPhase" ];
      installPhase = ''
        mkdir -p $out/share/xsessions
        cp $src/share/xsessions/euclid-mate-3d.desktop $out/share/xsessions/
      '';
    })
  ];
}
