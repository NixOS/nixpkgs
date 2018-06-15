{ stdenv, fetchurl, pkgconfig, fltk, openexr, libGLU_combined, openexr_ctl }:

assert fltk.glSupport;

stdenv.mkDerivation {
  name ="openexr_viewers-2.2.1";

  src = fetchurl {
    url =  "mirror://savannah/openexr/openexr_viewers-2.2.1.tar.gz";
    sha256 = "1ixx2wbjp4rvsf7h3bkja010gl1ihjrcjzy7h20jnn47ikg12vj8";
  };

  configurePhase = ''
    ./configure --prefix=$out --with-fltk-config=${fltk}/bin/fltk-config
  '';

  buildPahse = ''
    make LDFLAGS="`fltk-config --ldflags` -lGL -lfltk_gl"
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openexr fltk libGLU_combined openexr_ctl ];

  meta = { 
    description = "Application for viewing OpenEXR images on a display at various exposure settings";
    homepage = http://openexr.com;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsd3;
  };
}
