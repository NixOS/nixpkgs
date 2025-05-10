{
  lib,
  python3Packages,
  fetchFromGitHub,
  gtk3,
  dbus,
  networkmanager,
  bluez,
  pipewire,
  brightnessctl,
  power-profiles-daemon,
  gammastep,
  libpulseaudio,
  desktop-file-utils,
  wrapGAppsHook4,
  gobject-introspection,
  usbguard,
  upower,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "better-control";
  version = "v6.11.5";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "quantumvoid0";
    repo = "better-control";
    tag = version;
    hash = "sha256-ENpdSZnA0IA9ip3mOJq5rx/Kk6gvt6H4ngxdNS1Lwt0=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  nativeBuildInputs = [
    desktop-file-utils
    wrapGAppsHook4
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    dbus
    libpulseaudio
    networkmanager
    bluez
    pipewire
    brightnessctl
    power-profiles-daemon
    gammastep
    usbguard
    upower
  ];

  dependencies = with python3Packages; [
    pygobject3
    dbus-python
    pydbus
    psutil
    qrcode
    requests
    setproctitle
    pillow
    pycairo
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  dontWrapGApps = true;

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  postInstall = ''
    rm $out/bin/betterctl
    chmod +x $out/share/better-control/better_control.py
    substituteInPlace $out/bin/* \
      --replace-fail "/bin/bash" "/usr/bin/env bash" \
      --replace-fail "python3 " ""
    substituteInPlace $out/share/applications/better-control.desktop \
      --replace-fail "/usr/bin/" ""
  '';

  # Project has no tests
  doCheck = false;

  postFixup = ''
    wrapPythonProgramsIn "$out/share/better-control" "$out $pythonPath"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "System control panel utility";
    homepage = "https://github.com/quantumvoid0/better-control";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ Rishabh5321 ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "control"; # Users use both "control" and "better-control" to launch
  };
}
