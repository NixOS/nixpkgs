{stdenv, fetchurl, cmake, mesa, gettext, python, libjpeg, libpng, zlib, openal, SDL
, openexr, libsamplerate, libXi, libtiff, ilmbase, freetype}:

stdenv.mkDerivation rec {
  name = "blender-2.49b";

  src = fetchurl {
    url = "http://download.blender.org/source/${name}.tar.gz";
    sha256 = "1214fp2asij7l1sci2swh46nfjgpm72gk2qafq70xc0hmas4sm93";
  };

  buildInputs = [ cmake mesa gettext python libjpeg libpng zlib openal SDL openexr libsamplerate
    libXi libtiff ilmbase freetype ];

  cmakeFlags = [ "-DFREETYPE_INC=${freetype}/include" "-DOPENEXR_INC=${openexr}/include/OpenEXR" "-DWITH_OPENCOLLADA=OFF"
    "-DPYTHON_LIBPATH=${python}/lib" ];

  NIX_LDFLAGS = "-lX11";
  NIX_CFLAGS_COMPILE = "-iquote ${ilmbase}/include/OpenEXR -I${python}/include/${python.libPrefix} -I${freetype}/include/freetype2";

  installPhase = ''
    ensureDir $out/bin
    cp bin/* $out/bin
  '';

  meta = { 
    description = "3D Creation/Animation/Publishing System";
    homepage = http://www.blender.org;
    # They comment two licenses: GPLv2 and Blender License, but they
    # say: "The BL has not been activated yet."
    license = "GPLv2+";
  };
}
