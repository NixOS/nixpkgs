{ lib
, stdenv
, python3Packages
, fetchPypi
, wrapGAppsHook
, gtk3
, gobject-introspection
, libcanberra-gtk3
, poppler_gi
, withGstreamer ? stdenv.isLinux
, withVLC ? stdenv.isLinux
}:

python3Packages.buildPythonApplication rec {
  pname = "pympress";
  version = "1.8.4";

  src = fetchPypi {
    inherit version;
    pname = "pympress";
    hash = "sha256-3cnCHGoKUX0gTzIx1khM+br6x9+g9WXh28SLhm99eN4=";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    poppler_gi
  ] ++ lib.optional withGstreamer libcanberra-gtk3;

  propagatedBuildInputs = with python3Packages; [
    pycairo
    pygobject3
    setuptools
    watchdog
  ] ++ lib.optional withVLC python-vlc;

  doCheck = false; # there are no tests

  meta = with lib; {
    description = "Simple yet powerful PDF reader designed for dual-screen presentations";
    license = licenses.gpl2Plus;
    homepage = "https://cimbali.github.io/pympress/";
    maintainers = [ maintainers.tbenst ];
  };
}
