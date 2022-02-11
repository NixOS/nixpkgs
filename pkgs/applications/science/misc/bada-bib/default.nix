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
, gtk3
, libxml2
, pkg-config
, python3Packages
, wrapGAppsHook }:

python3Packages.buildPythonApplication rec {
  pname = "bada-bib";
  version = "0.3.0";
  format = "other";
  strictDeps = false; # https://github.com/NixOS/nixpkgs/issues/56943

  src = fetchFromGitHub {
    owner = "RogerCrocker";
    repo = "BadaBib";
    rev = "v${version}";
    sha256 = "0rclkkf5kd9ab049lizliiqawx5c5y2qmq40lkxnx09sa0283vg8";
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    libxml2
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    gtk3
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
