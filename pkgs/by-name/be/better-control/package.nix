{ lib
, stdenv
, fetchzip
, gtk3
, networkmanager
, bluez
, pipewire
, brightnessctl
, python3
, power-profiles-daemon
, gammastep
, libpulseaudio
, pulseaudio
, pkg-config
, wrapGAppsHook
, makeWrapper
, desktop-file-utils
, python3Packages
}:

stdenv.mkDerivation rec {
  pname = "better-control";
  version = "5.8";

  src = fetchzip {
    url = "https://github.com/quantumvoid0/better-control/archive/refs/tags/${version}.zip";
    sha256 = "1kijpnkyjvvjyvkk30h0x6n37jr77w14gi5ccasvcj0vlvngdm0m";
  };

  buildInputs = [
    gtk3
    networkmanager
    bluez
    pipewire
    brightnessctl
    python3
    python3Packages.pygobject3
    python3Packages.dbus-python
    python3Packages.pydbus
    python3Packages.psutil
    power-profiles-daemon
    python3Packages.qrcode
    python3Packages.requests
    python3Packages.pillow
    python3Packages.pycairo
    gammastep
    libpulseaudio
    pulseaudio
  ];

  nativeBuildInputs = [ pkg-config wrapGAppsHook makeWrapper desktop-file-utils ];

  dontBuild = true;
  sourceRoot = "source/";

  installPhase = ''
    mkdir -p $out/bin $out/share/better-control $out/share/applications
    cp -r src/* $out/share/better-control/
    cat > $out/bin/better-control << EOF
    #!/bin/sh
    exec python3 $out/share/better-control/better_control.py "\$@"
    EOF
    chmod +x $out/bin/better-control

    cat > $out/share/applications/better-control.desktop << EOF
    [Desktop Entry]
    Type=Application
    Name=Control Center
    GenericName=Control Center
    Comment=Fast & feature-rich control center
    TryExec=better-control
    StartupNotify=true
    Exec=$out/bin/better-control
    Icon=settings
    Categories=System;Control;Settings;
    EOF
  '';

  postFixup = ''
    wrapProgram $out/bin/better-control \
      --prefix PATH : ${lib.makeBinPath [
        python3 brightnessctl networkmanager bluez pipewire power-profiles-daemon
        gammastep libpulseaudio pulseaudio
      ]} \
      --prefix GI_TYPELIB_PATH : "${lib.makeSearchPath "lib/girepository-1.0" [
        gtk3 python3Packages.pygobject3
      ]}" \
      --set PYTHONPATH "$PYTHONPATH:${python3Packages.pygobject3}/${python3.sitePackages}" \
      --set DBUS_SYSTEM_BUS_ADDRESS "unix:path=/run/dbus/system_bus_socket"
  '';

  meta = with lib; {
    description = "A system control panel utility";
    homepage = "https://github.com/quantumvoid0/better-control";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "better-control";
    maintainers = with maintainers; [ quantumvoid nekrooo ];
  };
}
