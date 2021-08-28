{ lib
, fetchFromGitHub
, gtk3
, gettext
, json_c
, lcms2
, libpng
, librsvg
, gobject-introspection
, libmypaint
, hicolor-icon-theme
, mypaint-brushes
, gdk-pixbuf
, pkg-config
, python3
, swig
, wrapGAppsHook
}:

let
  inherit (python3.pkgs) pycairo pygobject3 numpy buildPythonApplication;
in buildPythonApplication rec {
  pname = "mypaint";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "mypaint";
    repo = "mypaint";
    rev = "v${version}";
    sha256 = "rVKcxzWZRLcuxK8xRyRgvitXAh4uOEyqHswLeTdA2Mk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    gettext
    pkg-config
    swig
    wrapGAppsHook
    gobject-introspection # for setup hook
    hicolor-icon-theme # fór setup hook
  ];

  buildInputs = [
    gtk3
    gdk-pixbuf
    libmypaint
    mypaint-brushes
    json_c
    lcms2
    libpng
    librsvg
    pycairo
    pygobject3

    # Mypaint checks for a presence of this theme scaffold and crashes when not present.
    hicolor-icon-theme
  ];

  propagatedBuildInputs = [
    numpy
    pycairo
    pygobject3
  ];

  checkInputs = [
    gtk3
  ];

  buildPhase = ''
    runHook preBuild

    ${python3.interpreter} setup.py build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${python3.interpreter} setup.py managed_install --prefix=$out

    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck

    HOME=$TEMPDIR ${python3.interpreter} setup.py test

    runHook postCheck
  '';

  meta = with lib; {
    description = "A graphics application for digital painters";
    homepage = "http://mypaint.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ goibhniu jtojnar ];
  };
}
