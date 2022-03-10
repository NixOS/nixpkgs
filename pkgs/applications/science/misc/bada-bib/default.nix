{ lib
, meson
, ninja
, fetchFromGitHub
, appstream-glib
, desktop-file-utils
, gdk-pixbuf
, gettext
, glib
, gnome
, gobject-introspection
, gtk4
, libxml2
, pkg-config
, python3Packages
, wrapGAppsHook4 }:

python3Packages.buildPythonApplication rec {
  pname = "bada-bib";
  version = "0.5.1";
  format = "other";
  strictDeps = false; # https://github.com/NixOS/nixpkgs/issues/56943

  src = fetchFromGitHub {
    owner = "RogerCrocker";
    repo = "BadaBib";
    rev = "v${version}";
    sha256 = "sha256-tb/720WPqcO4w1EMmidjtEidsjZ0dEhe+/vnJPM6kxo=";
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    libxml2
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    gtk4
  ];

  checkInputs = [
    appstream-glib
    desktop-file-utils
  ];

  pythonPath = with python3Packages; [
    bibtexparser
    pygobject3
    watchgod
  ];

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py
  '';

  dontWrapGApps = true; # Needs python wrapper

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postFixup = ''
    wrapPythonProgramsIn "$out/libexec" "$out $pythonPath"
  '';

  meta = with lib; {
    homepage = "https://github.com/RogerCrocker/BadaBib";
    description = "A simple BibTeX Viewer and Editor";
    maintainers = [ maintainers.Cogitri ];
    license = licenses.gpl3Plus;
  };
}
