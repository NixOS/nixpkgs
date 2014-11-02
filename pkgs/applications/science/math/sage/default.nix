{ stdenv, fetchurl, m4, perl, gfortran, texLive, ffmpeg, tk
, imagemagick, liblapack
}:

stdenv.mkDerivation rec {
  name = "sage-6.1.1";

  src = fetchurl {
    url = "http://mirrors.xmission.com/sage/src/sage-6.1.1.tar.gz";
    sha256 = "0kbzs0l9q7y34jv3f8rd1c2mrjsjkdgaw6mfdwjlpg9g4gghmq5y";
  };

  buildInputs = [ m4 perl gfortran texLive ffmpeg tk imagemagick liblapack ];

  enableParallelBuilding = true;

  preConfigure = ''
    export SAGE_NUM_THREADS=$NIX_BUILD_CORES
    sed -i 's/if ! [ -d "$HOME" ]/if [ -d "$HOME" ]/' src/bin/sage-env
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i "s/ld_version = try_run('ld  -v')/ld_version = 'Apple'/" \
      build/pkgs/atlas/configuration.py
  '';

  meta = {
    homepage = "http://www.sagemath.org";
    description = "A free open source mathematics software system";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
