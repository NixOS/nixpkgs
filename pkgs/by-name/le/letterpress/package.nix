{
  lib,
  fetchFromGitLab,
  fetchpatch,
  wrapGAppsHook4,
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  gettext,
  gobject-introspection,
  jp2a,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "letterpress";
  version = "2.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "letterpress";
    rev = version;
    hash = "sha256-9U8iH3V4WMljdtWLmb0RlexLeAN5StJ0c9RlEB2E7Xs=";
  };

  patches = [
    # Fix application segmentation fault on file chooser dialog opening
    # https://gitlab.gnome.org/World/Letterpress/-/merge_requests/16
    (fetchpatch {
      url = "https://gitlab.gnome.org/World/Letterpress/-/commit/15059eacca14204d1092a6e32ef30c6ce4df6d36.patch";
      hash = "sha256-pjg/O9advtkZ0l73GQtL/GYcTWeOs5l3VGOdnsZCWI0=";
    })
  ];

  runtimeDeps = [
    jp2a
  ];

  buildInputs = [
    libadwaita
  ];

  nativeBuildInputs = [
    appstream
    blueprint-compiler
    desktop-file-utils
    gettext
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  dependencies = with python3Packages; [
    pillow
    pygobject3
  ];

  pyproject = false; # built by meson
  dontWrapGApps = true; # prevent double wrapping

  preFixup = ''
    makeWrapperArgs+=(''${gappsWrapperArgs[@]} --prefix PATH : ${ lib.makeBinPath runtimeDeps })
  '';

  meta = with lib; {
    description = "Create beautiful ASCII art";
    longDescription = ''
      Letterpress converts your images into a picture made up of ASCII characters.
      You can save the output to a file, copy it, and even change its resolution!
      High-res output can still be viewed comfortably by lowering the zoom factor.
    '';
    homepage = "https://apps.gnome.org/Letterpress/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.dawidd6 ];
    platforms = platforms.linux;
    mainProgram = "letterpress";
  };
}
