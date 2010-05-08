{stdenv, fetchurl, cmake, mesa, gettext, python, libjpeg, libpng, zlib, openal, SDL
, openexr, libsamplerate, libXi, libtiff, ilmbase }:

stdenv.mkDerivation {
  name = "blender-2.50a";

  src = fetchurl {
    url = http://download.blender.org/source/blender-2.50a1.tar.gz;
    sha256 = "1cik05fmf9b8z3qpwsm6q9h1ia87w1piz87hxhfs24jw6l5pyiwr";
  };

  buildInputs = [ cmake mesa gettext python libjpeg libpng zlib openal SDL openexr libsamplerate
    libXi libtiff ilmbase ];

  cmakeFlags = [ "-DOPENEXR_INC=${openexr}/include/OpenEXR" "-DWITH_OPENCOLLADA=OFF"
    "-DPYTHON_LIBPATH=${python}/lib" ];

  NIX_CFLAGS_COMPILE = "-iquote ${ilmbase}/include/OpenEXR -I${python}/include/${python.libPrefix}";

  patches = [ ./python-chmod.patch ];

  meta = { 
    description = "3D Creation/Animation/Publishing System";
    homepage = http://www.blender.org;
    # They comment two licenses: GPLv2 and Blender License, but they
    # say: "We've decided to cancel the BL offering for an indefinite period."
    license = "GPLv2+";
  };
}
