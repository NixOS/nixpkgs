{ stdenv
, fetchFromGitHub
, gtk3
, intltool
, json_c
, lcms2
, libpng
, librsvg
, gobject-introspection
, gdk-pixbuf
, pkgconfig
, python2
, scons
, swig
, wrapGAppsHook
}:

let
  inherit (python2.pkgs) pycairo pygobject3 numpy;
in stdenv.mkDerivation {
  pname = "mypaint";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "mypaint";
    repo = "mypaint";
    rev = "bcf5a28d38bbd586cc9d4cee223f849fa303864f";
    sha256 = "1zwx7n629vz1jcrqjqmw6vl6sxdf81fq6a5jzqiga8167gg8s9pf";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    intltool
    pkgconfig
    scons
    swig
    wrapGAppsHook
    gobject-introspection # for setup hook
  ];

  buildInputs = [
    gtk3
    gdk-pixbuf
    json_c
    lcms2
    libpng
    librsvg
    pycairo
    pygobject3
    python2
  ];

  propagatedBuildInputs = [
    numpy
  ];

  postInstall = ''
    sed -i -e 's|/usr/bin/env python2.7|${python2}/bin/python|' $out/bin/mypaint
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix PYTHONPATH : $PYTHONPATH)
  '';

  meta = with stdenv.lib; {
    description = "A graphics application for digital painters";
    homepage = "http://mypaint.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ goibhniu jtojnar ];
  };
}
