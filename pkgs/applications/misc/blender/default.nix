{ stdenv, fetchurl, SDL, cmake, gettext, ilmbase, libXi, libjpeg,
libpng, libsamplerate, libtiff, mesa, openal, openexr, openjpeg,
python, zlib, boost }:

stdenv.mkDerivation rec {
  name = "blender-2.62";

  src = fetchurl {
    url = "http://download.blender.org/source/${name}.tar.gz";
    sha256 = "19xfr5vx66p4p3hnqpglpky6f4bh3ay484mdgh7zg6j9f80dp53q";
  };

  buildInputs = [ cmake mesa gettext python libjpeg libpng zlib openal
    SDL openexr libsamplerate libXi libtiff ilmbase openjpeg boost ];

  cmakeFlags = [
    "-DOPENEXR_INC=${openexr}/include/OpenEXR"
    "-DWITH_OPENCOLLADA=OFF"
    "-DWITH_INSTALL_PORTABLE=OFF"
    "-DPYTHON_LIBPATH=${python}/lib"
  ];

  NIX_CFLAGS_COMPILE = "-iquote ${ilmbase}/include/OpenEXR -I${python}/include/${python.libPrefix}";

  meta = { 
    description = "3D Creation/Animation/Publishing System";
    homepage = http://www.blender.org;
    # They comment two licenses: GPLv2 and Blender License, but they
    # say: "We've decided to cancel the BL offering for an indefinite period."
    license = "GPLv2+";
  };
}
