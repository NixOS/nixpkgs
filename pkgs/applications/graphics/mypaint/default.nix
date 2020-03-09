{ stdenv
, fetchFromGitHub
, gtk3
, intltool
, json_c
, lcms2
, libpng
, librsvg
, gobject-introspection
, libmypaint
, mypaint-brushes
, gdk-pixbuf
, pkgconfig
, python3
, swig
, wrapGAppsHook
}:

let
  inherit (python3.pkgs) pycairo pygobject3 numpy buildPythonApplication;
in buildPythonApplication rec {
  pname = "mypaint";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "mypaint";
    repo = "mypaint";
    rev = "v${version}";
    sha256 = "180kyilhf81ndhwl1hlvy82gh6hxpcvka2d1nkghbpgy431rls6r";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    intltool
    pkgconfig
    swig
    wrapGAppsHook
    gobject-introspection # for setup hook
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

  meta = with stdenv.lib; {
    description = "A graphics application for digital painters";
    homepage = "http://mypaint.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ goibhniu jtojnar ];
  };
}
