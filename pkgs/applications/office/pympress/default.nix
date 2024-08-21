{ lib
, stdenv
, python3Packages
, fetchPypi
, wrapGAppsHook3
, gtk3
, gobject-introspection
, libcanberra-gtk3
, poppler_gi
, withGstreamer ? stdenv.isLinux
, gst_all_1
, withVLC ? stdenv.isLinux
}:

python3Packages.buildPythonApplication rec {
  pname = "pympress";
  version = "1.8.5";

  src = fetchPypi {
    inherit version;
    pname = "pympress";
    hash = "sha256-Kb05EV0F8lTamTq7pC1UoOkYf04s58NjMksVE2xTC/Y=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    poppler_gi
  ] ++ lib.optionals withGstreamer [
    libcanberra-gtk3
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    (gst_all_1.gst-plugins-good.override {gtkSupport = true;})
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi
  ];

  propagatedBuildInputs = with python3Packages; [
    pycairo
    pygobject3
    setuptools
    watchdog
  ] ++ lib.optional withVLC python-vlc;

  doCheck = false; # there are no tests

  meta = with lib; {
    description = "Simple yet powerful PDF reader designed for dual-screen presentations";
    mainProgram = "pympress";
    license = licenses.gpl2Plus;
    homepage = "https://cimbali.github.io/pympress/";
    maintainers = [ maintainers.tbenst ];
  };
}
