{ lib, stdenv, makeWrapper, bash }:

stdenv.mkDerivation {
  pname = "euclid-wayfire-session";
  version = "1.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/wayland-sessions

    cp start-euclid-budgie-wayfire $out/bin/
    chmod +x $out/bin/start-euclid-budgie-wayfire

    cp start-euclid-wayfire $out/bin/
    chmod +x $out/bin/start-euclid-wayfire

    cat << 'EOF' > $out/share/wayland-sessions/euclid-budgie-wayfire.desktop
[Desktop Entry]
Name=Euclid Linux 3D — Budgie + Wayfire
Comment=Euclid Linux 3D desktop powered by Budgie and Wayfire
Exec=start-euclid-budgie-wayfire
TryExec=start-euclid-budgie-wayfire
Type=Application
DesktopNames=Budgie;Wayfire;Euclid;
X-GDM-SessionRegisters=true
EOF

    cat << 'EOF' > $out/share/wayland-sessions/euclid-wayfire.desktop
[Desktop Entry]
Name=Euclid Wayfire Desktop — wf-shell
Comment=Euclid Linux 3D desktop powered by pure Wayfire
Exec=start-euclid-wayfire
TryExec=start-euclid-wayfire
Type=Application
DesktopNames=Wayfire;Euclid;
X-GDM-SessionRegisters=true
EOF
  '';

  passthru.providedSessions = [ "euclid-budgie-wayfire" "euclid-wayfire" ];

  meta = {
    description = "Euclid Linux 3D Budgie + Wayfire Session Script";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
