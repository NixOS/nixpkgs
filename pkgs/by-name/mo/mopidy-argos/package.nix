{
  stdenv,
  lib,
  python3Packages,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  appstream-glib,
  desktop-file-utils,
  wrapGAppsHook3,
  gobject-introspection,
}:
python3Packages.buildPythonApplication rec {
  pname = "mopidy-argos";
  version = "1.19.1";
  pyproject = false; # Built with meson

  src = fetchFromGitHub {
    owner = "orontee";
    repo = "argos";
    tag = "v${version}";
    hash = "sha256-7H+4bISOm7tdv8JLOSee+hof9zjR8gRpaBFYWeD8mBw=";
  };
  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py
  '';

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    appstream-glib
    gobject-introspection
    desktop-file-utils
    wrapGAppsHook3
  ];

  dependencies = with python3Packages; [
    aiohttp
    pycairo
    pygobject3
    pyxdg
    zeroconf
  ];

  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    homepage = "https://github.com/orontee/argos";
    description = "Gtk front-end to control a Mopidy server";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.hufman ];
    mainProgram = "argos";
  };
}
