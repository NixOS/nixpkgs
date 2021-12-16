{ lib
, stdenv
, python3Packages
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
  version = "1.7.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-AxH0PyAWYEEIqQAx9gG2eYyXMijLZGZqXkRhld32ieE=";
  };

  nativeBuildInputs = [
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    gobject-introspection
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
