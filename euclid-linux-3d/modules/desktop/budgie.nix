{ config, pkgs, lib, ... }: {
  services.xserver.enable = true;
  services.desktopManager.budgie.enable = true;

  services.displayManager.sessionPackages = [
    (pkgs.stdenv.mkDerivation {
      name = "euclid-budgie-compiz-session";
      src = pkgs.writeTextFile {
        name = "euclid-budgie-compiz.desktop";
        destination = "/share/xsessions/euclid-budgie-compiz.desktop";
        text = ''
          [Desktop Entry]
          Name=Euclid Linux 3D Budgie+Compiz
          Comment=Budgie Desktop with Compiz Reloaded
          Exec=env BUDGIE_WM=compiz budgie-desktop
          TryExec=budgie-desktop
          Icon=euclid-session-budgie-compiz
          Type=Application
          DesktopNames=Budgie;GNOME
        '';
      };
      passthru.providedSessions = [ "euclid-budgie-compiz" ];
      phases = [ "installPhase" ];
      installPhase = ''
        mkdir -p $out/share/xsessions
        cp $src/share/xsessions/euclid-budgie-compiz.desktop $out/share/xsessions/
      '';
    })
  ];

  # Set default session to the new one
  services.displayManager.defaultSession = "euclid-budgie-compiz";
}
