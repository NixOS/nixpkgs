{ lib
, python3Packages
, wrapGAppsHook
, xvfb_run
, gtk3
, gobject-introspection
, libcanberra-gtk3
, dbus
, poppler_gi
, python3
 }:

python3Packages.buildPythonApplication rec {
  pname = "pympress";
  version = "1.4.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "101wj6m931bj0ah6niw79i8ywb5zlb2783g7n7dmkhw6ay3jj4vq";
  };

  nativeBuildInputs = [
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    gobject-introspection
    libcanberra-gtk3
    poppler_gi
  ];

  propagatedBuildInputs = with python3Packages; [
    pycairo
    pygobject3
    python-vlc
    watchdog
  ];

  doCheck = false; # there are no tests

  meta = with lib; {
    description = "Simple yet powerful PDF reader designed for dual-screen presentations";
    license = licenses.gpl2Plus;
    homepage = "https://cimbali.github.io/pympress/";
    maintainers = [ maintainers.tbenst ];
  };
}
