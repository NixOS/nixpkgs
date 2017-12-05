{ stdenv, fetchurl, pkgconfig, fltk, openexr, mesa, openexr_ctl }:

assert fltk.glSupport;

stdenv.mkDerivation {
  name ="openexr_viewers-2.2.0";

  src = fetchurl {
    url =  "mirror://savannah/openexr/openexr_viewers-2.2.0.tar.gz";
    sha256 = "1s84vnas12ybx8zz0jcmpfbk9m4ab5bg2d3cglqwk3wys7jf4gzp";
  };

  configurePhase = ''
    ./configure --prefix=$out --with-fltk-config=${fltk}/bin/fltk-config
  '';

  buildPahse = ''
    make LDFLAGS="`fltk-config --ldflags` -lGL -lfltk_gl"
  '';

  buildInputs = [ openexr fltk pkgconfig mesa openexr_ctl ];

  meta = { 
    description = "Application for viewing OpenEXR images on a display at various exposure settings";
    homepage = http://openexr.com;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsd3;
  };
}
