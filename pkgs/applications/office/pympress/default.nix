{ lib
, stdenv
, fetchpatch
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
  version = "1.6.3";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-f+OjE0x/3yfJYHCLB+on7TT7MJ2vNu87SHRi67qFDCM=";
  };

  patches = [
    # Should not be needed once v1.6.4 is released
    (fetchpatch {
      name = "fix-setuptools-version-parsing.patch";
      url = "https://github.com/Cimbali/pympress/commit/474514d71396ac065e210fd846e07ed1139602d0.diff";
      sha256 = "sha256-eiw54sjMrXrNrhtkAXxiSTatzoA0NDA03L+HpTDax58=";
    })
  ];

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
