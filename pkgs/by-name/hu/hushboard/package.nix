{
  lib,
  python3Packages,
  fetchFromGitHub,
  gobject-introspection,
  gtk3,
  libappindicator,
  libpulseaudio,
  librsvg,
  wrapGAppsHook3,
  nix-update-script,
  fetchpatch,
}:

python3Packages.buildPythonApplication {
  pname = "hushboard";
  version = "0-unstable-2024-04-28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stuartlangridge";
    repo = "hushboard";
    rev = "13f5e62add99355f90798006742f62397be8be0c";
    hash = "sha256-z5ZSqcdKUHWt7kgW7ISZJei2YzVZHJGOqJ2IXv3qiWQ=";
  };

  patches = [
    # https://github.com/stuartlangridge/hushboard/pull/30
    (fetchpatch {
      url = "https://github.com/stuartlangridge/hushboard/commit/b17b58cd00eb9af8184f8dcb010bbae7f9bc470c.patch";
      hash = "sha256-C03hq2ttXY8DJzrarQvFIzo29d+owZVIHZRA28fq7Z8=";
    })
  ];

  build-system = with python3Packages; [ setuptools ];

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    libappindicator
    libpulseaudio
  ];

  propagatedBuildInputs = with python3Packages; [
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

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  # no tests
  doCheck = false;

  pythonImportsCheck = [
    "hushboard"
  ];

  meta = {
    homepage = "https://kryogenix.org/code/hushboard/";
    license = lib.licenses.mit;
    description = "Mute your microphone while typing";
    mainProgram = "hushboard";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ keysmashes ];
  };
}
