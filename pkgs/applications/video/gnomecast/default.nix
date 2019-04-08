{ lib, python3Packages, gtk3, gobject-introspection, ffmpeg, wrapGAppsHook }:

with python3Packages;
buildPythonApplication rec {
  pname = "gnomecast";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mn03gqbwmhch0055bzgdwkzsl304qdyqwrgyiq0k5c5d2gyala5";
  };

  nativeBuildInputs = [ wrapGAppsHook ];
  propagatedBuildInputs = [
    PyChromecast bottle pycaption paste html5lib pygobject3 dbus-python
    gtk3 gobject-introspection
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ ffmpeg ]})
  '';

  meta = with lib; {
    description = "A native Linux GUI for Chromecasting local files";
    homepage = https://github.com/keredson/gnomecast;
    license = with licenses; [ gpl3 ];
  };
}
