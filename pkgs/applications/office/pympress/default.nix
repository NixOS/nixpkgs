{ lib
, stdenv
, python3Packages
<<<<<<< HEAD
, fetchPypi
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, wrapGAppsHook
, gtk3
, gobject-introspection
, libcanberra-gtk3
, poppler_gi
, withGstreamer ? stdenv.isLinux
, withVLC ? stdenv.isLinux
<<<<<<< HEAD
}:
=======
 }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3Packages.buildPythonApplication rec {
  pname = "pympress";
  version = "1.7.2";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3Packages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    sha256 = "LFUzrGHr8jmUqoIcKokC0gNDVmW1EUZlj9eI+GDycvI=";
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
