{ stdenv, fetchFromGitHub, gtk3, intltool, json_c, lcms2, libpng, librsvg, gobject-introspection, hicolor-icon-theme
, gdk_pixbuf, pkgconfig, python2Packages, scons, swig, wrapGAppsHook }:

let
  inherit (python2Packages) python pycairo pygobject3 numpy;
in stdenv.mkDerivation rec {
  name = "mypaint-${version}";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "mypaint";
    repo = "mypaint";
    rev = "bcf5a28d38bbd586cc9d4cee223f849fa303864f";
    sha256 = "1zwx7n629vz1jcrqjqmw6vl6sxdf81fq6a5jzqiga8167gg8s9pf";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    intltool pkgconfig scons swig wrapGAppsHook
    gobject-introspection # for setup hook
  ];

  buildInputs = [
    gtk3 gdk_pixbuf json_c lcms2 libpng librsvg pycairo pygobject3 python hicolor-icon-theme
  ];

  propagatedBuildInputs = [ numpy ];

  postInstall = ''
    sed -i -e 's|/usr/bin/env python2.7|${python}/bin/python|' $out/bin/mypaint
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix PYTHONPATH : $PYTHONPATH)
  '';

  meta = with stdenv.lib; {
    description = "A graphics application for digital painters";
    homepage = http://mypaint.org/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ goibhniu jtojnar ];
  };
}
