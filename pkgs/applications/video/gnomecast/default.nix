{ stdenv, lib, python3Packages, gtk3, gobject-introspection, ffmpeg, wrapGAppsHook }:

with python3Packages;
buildPythonApplication rec {
  pname = "gnomecast";
  version = "1.9.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4d8cd7a71f352137252c5a9ee13475bd67fb99594560ecff1efb0f718d8bbaac";
  };

  nativeBuildInputs = [ wrapGAppsHook ];
  propagatedBuildInputs = [
    PyChromecast bottle pycaption paste html5lib pygobject3 dbus-python
    gtk3 gobject-introspection
  ];

  # NOTE: gdk-pixbuf setup hook does not run with strictDeps
  # https://nixos.org/manual/nixpkgs/stable/#ssec-gnome-hooks-gobject-introspection
  strictDeps = false;

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ ffmpeg ]})
  '';

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "A native Linux GUI for Chromecasting local files";
    homepage = "https://github.com/keredson/gnomecast";
    license = with licenses; [ gpl3 ];
    broken = stdenv.isDarwin;
  };
}
