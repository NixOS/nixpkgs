{ stdenv, fetchurl, gettext, glib, gtk2, hicolor_icon_theme, json_c
, lcms2, libpng , makeWrapper, pkgconfig, pythonPackages
, scons, swig
}:

let
  inherit (pythonPackages) python pygtk numpy;
in stdenv.mkDerivation rec {
  name = "mypaint-${version}";
  version = "1.1.0";

  src = fetchurl {
    url = "http://download.gna.org/mypaint/${name}.tar.bz2";
    sha256 = "0f7848hr65h909c0jkcx616flc0r4qh53g3kd1cgs2nr1pjmf3bq";
  };

  buildInputs = [
    gettext glib gtk2 json_c lcms2 libpng makeWrapper pkgconfig pygtk
    python scons swig
  ];

  propagatedBuildInputs = [ hicolor_icon_theme numpy ];

  buildPhase = "scons prefix=$out";

  installPhase = ''
    scons prefix=$out install
    sed -i -e 's|/usr/bin/env python2.7|${python}/bin/python|' $out/bin/mypaint
    wrapProgram $out/bin/mypaint \
      --prefix PYTHONPATH : $PYTHONPATH \
      --prefix XDG_DATA_DIRS ":" "${hicolor_icon_theme}/share"
  '';

  meta = with stdenv.lib; {
    description = "A graphics application for digital painters";
    homepage = http://mypaint.intilinux.com;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
