{ stdenv, lib, fetchurl, fetchpatch, SDL, boost, cmake, ffmpeg, gettext, glew
, ilmbase, libXi, libjpeg, libpng, libsamplerate, libsndfile
, libtiff, mesa, openal, opencolorio, openexr, openimageio, openjpeg, python
, zlib, fftw
, jackaudioSupport ? false, jack2
}:

with lib;

stdenv.mkDerivation rec {
  name = "blender-2.71";

  src = fetchurl {
    url = "http://download.blender.org/source/${name}.tar.gz";
    sha256 = "18pzcnrs4rcb6mf6aqr9xj2r05v8aay8daj31395ljfzw667zakx";
  };

  buildInputs =
    [ SDL boost cmake ffmpeg gettext glew ilmbase libXi
      libjpeg libpng libsamplerate libsndfile libtiff mesa openal
      opencolorio openexr openimageio /* openjpeg */ python zlib fftw
    ] ++ optional jackaudioSupport jack2;

  postUnpack =
    ''
      substituteInPlace */doc/manpage/blender.1.py --replace /usr/bin/python ${python}/bin/python3
    '';

  patches = [(fetchpatch { # fix parallel builds
    url = "https://developer.blender.org/D619?download=true";
    sha256 = "18h4fqsbpwxzqz7qby18lrrbzqnyd5xnann3xcac5wddwv5wjb0f";
    name = "D619.diff";
  })];
  patchFlags = "-p0";

  cmakeFlags =
    [ "-DOPENEXR_INC=${openexr}/include/OpenEXR"
      "-DWITH_OPENCOLLADA=OFF"
      "-DWITH_MOD_OCEANSIM=ON"
      "-DWITH_CODEC_FFMPEG=ON"
      "-DWITH_CODEC_SNDFILE=ON"
      "-DWITH_INSTALL_PORTABLE=OFF"
      "-DPYTHON_LIBRARY=python${python.majorVersion}m"
      "-DPYTHON_LIBPATH=${python}/lib"
      "-DPYTHON_INCLUDE_DIR=${python}/include/python${python.majorVersion}m"
      "-DPYTHON_VERSION=${python.majorVersion}"
    ]
    ++ optional jackaudioSupport "-DWITH_JACK=ON";

  NIX_CFLAGS_COMPILE = "-I${ilmbase}/include/OpenEXR -I${python}/include/${python.libPrefix}m";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "3D Creation/Animation/Publishing System";
    homepage = http://www.blender.org;
    # They comment two licenses: GPLv2 and Blender License, but they
    # say: "We've decided to cancel the BL offering for an indefinite period."
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
