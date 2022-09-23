{ lib, stdenv, fetchurl, pkg-config, fltk, openexr, libGLU, libGL, ctl }:

stdenv.mkDerivation rec {
  pname = "openexr_viewers";
  version = "2.2.1";

  src = fetchurl {
    url = "mirror://savannah/openexr/openexr_viewers-${version}.tar.gz";
    sha256 = "1ixx2wbjp4rvsf7h3bkja010gl1ihjrcjzy7h20jnn47ikg12vj8";
  };

  configurePhase = ''
    ./configure --prefix=$out --with-fltk-config=${fltk}/bin/fltk-config
  '';

  buildPhase = ''
    make LDFLAGS="`fltk-config --ldflags` -lGL -lfltk_gl"
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openexr fltk libGLU libGL ctl ];

  meta = {
    description = "Application for viewing OpenEXR images on a display at various exposure settings";
    homepage = "http://openexr.com";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
  };
}
