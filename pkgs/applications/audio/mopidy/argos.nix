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
  python3,
  wrapGAppsHook3,
  gobject-introspection,
}:
stdenv.mkDerivation rec {
  pname = "mopidy-argos";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "orontee";
    repo = "argos";
    rev = "refs/tags/v${version}";
    sha256 = "1G4o5gltRpgn4hu8+xBhx8YMjUwbmFRevFfmweQMFLA=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    appstream-glib
    desktop-file-utils
    python3
    wrapGAppsHook3
    python3Packages.wrapPython
  ];

  propagatedBuildInputs =
    [
      gobject-introspection
    ]
    ++ (with python3Packages; [
      aiohttp
      pycairo
      pygobject3
      pyxdg
      zeroconf
    ]);

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py
  '';
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';
  postFixup = ''
    wrapPythonPrograms
  '';

  meta = {
    homepage = "https://github.com/orontee/argos";
    description = "Gtk front-end to control a Mopidy server";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.hufman ];
    mainProgram = "argos";
  };
}
