{ stdenv, fetchurl, SDL, cmake, gettext, ilmbase, libXi, libjpeg,
libpng, libsamplerate, libtiff, mesa, openal, openexr, openjpeg,
python, zlib }:

stdenv.mkDerivation rec {
  name = "blender-2.57";

  src = fetchurl {
    url = "http://download.blender.org/source/${name}.tar.gz";
    sha256 = "1f4l0zkfmbd8ydzwvmb5jw89y7ywd9k8m2f1b3hrdpgjcqhq3lcb";
  };

  buildInputs = [ cmake mesa gettext python libjpeg libpng zlib openal
    SDL openexr libsamplerate libXi libtiff ilmbase openjpeg ];

  patchPhase = ''
      sed -e "s@/usr/local@${python}@" -i build_files/cmake/FindPythonLibsUnix.cmake
  '';

  cmakeFlags = [ "-DOPENEXR_INC=${openexr}/include/OpenEXR"
    "-DWITH_OPENCOLLADA=OFF" "-DWITH_INSTALL_PORTABLE=OFF"];

  NIX_CFLAGS_COMPILE = "-iquote ${ilmbase}/include/OpenEXR -I${python}/include/${python.libPrefix}";

  meta = { 
    description = "3D Creation/Animation/Publishing System";
    homepage = http://www.blender.org;
    # They comment two licenses: GPLv2 and Blender License, but they
    # say: "We've decided to cancel the BL offering for an indefinite period."
    license = "GPLv2+";
  };
}
