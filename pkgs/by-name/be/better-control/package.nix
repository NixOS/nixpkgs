{
  lib,
  python3Packages,
  fetchFromGitHub,
  gtk3,
  networkmanager,
  bluez,
  pipewire,
  brightnessctl,
  power-profiles-daemon,
  gammastep,
  libpulseaudio,
  pulseaudio,
  desktop-file-utils,
  wrapGAppsHook4,
  gobject-introspection,
}:

python3Packages.buildPythonApplication rec {
  pname = "better-control";
  version = "5.9";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "quantumvoid0";
    repo = "better-control";
    tag = version;
    hash = "sha256-5y7+aJl1QsSgo/R9I4KRG8/WnY1WGEZKk9vzwvlK1i0=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    wrapGAppsHook4
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    libpulseaudio
  ];

  dependencies =
    [
      networkmanager
      bluez
      pipewire
      brightnessctl
      power-profiles-daemon
      gammastep
      pulseaudio
    ]
    ++ (with python3Packages; [
      pygobject3
      dbus-python
      pydbus
      psutil
      qrcode
      requests
      pillow
      pycairo
    ]);

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  dontWrapPythonPrograms = true;

  dontWrapGApps = true;

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  postInstall = ''
    rm $out/bin/control
    chmod +x $out/share/better-control/better_control.py
    substituteInPlace $out/bin/better-control \
      --replace-fail "/bin/bash" "/usr/bin/env bash" \
      --replace-fail "python3 " ""
    substituteInPlace $out/share/applications/better-control.desktop \
      --replace-fail "/usr/bin/" ""
  '';

  postFixup = ''
    wrapPythonProgramsIn "$out/share/better-control" "$out $pythonPath"
  '';

  meta = {
    description = "System control panel utility";
    homepage = "https://github.com/quantumvoid0/better-control";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ Rishabh5321 ];
    platforms = lib.platforms.linux;
    mainProgram = "better-control";
  };
}
