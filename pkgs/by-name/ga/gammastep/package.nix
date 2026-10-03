{
  lib,
  stdenv,
  fetchFromGitLab,
  autoconf,
  automake,
  gettext,
  intltool,
  libtool,
  pkg-config,
  wrapGAppsHook3,
  gobject-introspection,
  wayland-scanner,
  gtk3,
  python3Packages,

  withQuartz ? stdenv.hostPlatform.isDarwin,
  withRandr ? stdenv.hostPlatform.isLinux,
  libxcb,
  withDrm ? stdenv.hostPlatform.isLinux,
  libdrm,
  withVidmode ? stdenv.hostPlatform.isLinux,
  libxxf86vm,

  withGeolocation ? true,
  withCoreLocation ? withGeolocation && stdenv.hostPlatform.isDarwin,
  withGeoclue ? withGeolocation && stdenv.hostPlatform.isLinux,
  geoclue2,
  geoclue ? geoclue2,
  withAppIndicator ? stdenv.hostPlatform.isLinux,
  libayatana-appindicator,
}:

stdenv.mkDerivation rec {
  pname = "gammastep";
  version = "2.0.11";

  src = fetchFromGitLab {
    owner = "chinstrap";
    repo = "gammastep";
    rev = "v${version}";
    hash = "sha256-c8JpQLHHLYuzSC9bdymzRTF6dNqOLwYqgwUOpKcgAEU=";
  };

  strictDeps = true;

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    autoconf
    automake
    gettext
    intltool
    libtool
    pkg-config
    wrapGAppsHook3
    python3Packages.wrapPython
    gobject-introspection
    python3Packages.python
    wayland-scanner
  ];

  configureFlags = [
    "--enable-randr=${lib.boolToYesNo withRandr}"
    "--enable-geoclue2=${lib.boolToYesNo withGeoclue}"
    "--enable-drm=${lib.boolToYesNo withDrm}"
    "--enable-vidmode=${lib.boolToYesNo withVidmode}"
    "--enable-quartz=${lib.boolToYesNo withQuartz}"
    "--enable-corelocation=${lib.boolToYesNo withCoreLocation}"
    "--with-systemduserunitdir=${placeholder "out"}/lib/systemd/user/"
    "--enable-apparmor"
  ];

  buildInputs = [
    gtk3
  ]
  ++ lib.optional withRandr libxcb
  ++ lib.optional withGeoclue geoclue
  ++ lib.optional withDrm libdrm
  ++ lib.optional withVidmode libxxf86vm
  ++ lib.optional withAppIndicator libayatana-appindicator;

  pythonPath = [
    python3Packages.pygobject3
    python3Packages.pyxdg
  ];

  preConfigure = "./bootstrap";

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postFixup = ''
    wrapPythonPrograms
    wrapGApp $out/bin/gammastep
  '';

  # the geoclue agent may inspect these paths and expect them to be
  # valid without having the correct $PATH set
  postInstall = ''
    substituteInPlace $out/share/applications/gammastep.desktop \
      --replace 'Exec=gammastep' "Exec=$out/bin/gammastep"
    substituteInPlace $out/share/applications/gammastep-indicator.desktop \
      --replace 'Exec=gammastep-indicator' "Exec=$out/bin/gammastep-indicator"
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Screen color temperature manager";
    longDescription = ''
      Gammastep adjusts the color temperature according to the position
      of the sun. A different color temperature is set during night and
      daytime. During twilight and early morning, the color temperature
      transitions smoothly from night to daytime temperature to allow
      your eyes to slowly adapt. At night the color temperature should
      be set to match the lamps in your room.
    '';
    license = lib.licenses.gpl3Plus;
    homepage = "https://gitlab.com/chinstrap/gammastep";
    platforms = lib.platforms.unix;
    mainProgram = "gammastep";
    maintainers = with lib.maintainers; [ acidbong ];
  };
}
