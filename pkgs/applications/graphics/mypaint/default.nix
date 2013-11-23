{ stdenv, fetchurl, gettext, glib, gtk, json_c, lcms2, libpng
, makeWrapper, pkgconfig, pygtk, python, pythonPackages, scons, swig
}:

stdenv.mkDerivation rec {
  name = "mypaint-${version}";
  version = "1.1.0";

  src = fetchurl {
    url = "http://download.gna.org/mypaint/${name}.tar.bz2";
    sha256 = "0f7848hr65h909c0jkcx616flc0r4qh53g3kd1cgs2nr1pjmf3bq";
  };

  buildInputs = [ 
    gettext glib gtk json_c lcms2 libpng makeWrapper pkgconfig pygtk
    python scons swig
  ];
 
  propagatedBuildInputs = [ pythonPackages.numpy ];

  buildPhase = "scons prefix=$out";

  installPhase = ''
    scons prefix=$out install
    sed -i -e 's|/usr/bin/env python2.7|${python}/bin/python|' $out/bin/mypaint
    wrapProgram $out/bin/mypaint --prefix PYTHONPATH : $PYTHONPATH
  '';

  meta = with stdenv.lib; {
    description = "A graphics application for digital painters";
    homepage = http://mypaint.intilinux.com;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
