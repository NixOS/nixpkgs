{ lib
, buildPythonApplication
, fetchFromGitHub
, gobject-introspection
, gtk3
, libappindicator
, libpulseaudio
, librsvg
, pycairo
, pygobject3
, six
, wrapGAppsHook3
, xlib
}:

buildPythonApplication {
  pname = "hushboard";
  version = "unstable-2021-03-17";

  src = fetchFromGitHub {
    owner = "stuartlangridge";
    repo = "hushboard";
    rev = "c16611c539be111891116a737b02c5fb359ad1fc";
    sha256 = "06jav6j0bsxhawrq31cnls8zpf80fpwk0cak5s82js6wl4vw2582";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    libappindicator
    libpulseaudio
  ];

  propagatedBuildInputs = [
    pycairo
    pygobject3
    six
    xlib
  ];

  postPatch = ''
    substituteInPlace hushboard/_pulsectl.py \
      --replace "ctypes.util.find_library('libpulse') or 'libpulse.so.0'" "'${libpulseaudio}/lib/libpulse.so.0'"
    substituteInPlace snap/gui/hushboard.desktop \
      --replace "\''${SNAP}/hushboard/icons/hushboard.svg" "hushboard"
  '';

  postInstall = ''
    # Fix tray icon, see e.g. https://github.com/NixOS/nixpkgs/pull/43421
    wrapProgram $out/bin/hushboard \
      --set GDK_PIXBUF_MODULE_FILE "${librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"

    mkdir -p $out/share/applications $out/share/icons/hicolor/{scalable,512x512}/apps
    cp snap/gui/hushboard.desktop $out/share/applications
    cp hushboard/icons/hushboard.svg $out/share/icons/hicolor/scalable/apps
    cp hushboard-512.png $out/share/icons/hicolor/512x512/apps/hushboard.png
  '';

  # There are no tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://kryogenix.org/code/hushboard/";
    license = licenses.mit;
    description = "Mute your microphone while typing";
    mainProgram = "hushboard";
    platforms = platforms.linux;
    maintainers = with maintainers; [ sersorrel ];
  };
}
