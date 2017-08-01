{ stdenv, fetchurl, m4, perl, gfortran, texlive, ffmpeg, tk, gnused_422
, imagemagick, liblapack, python, openssl, libpng 
, which
}:

stdenv.mkDerivation rec {
  name = "sage-6.8";

  src = fetchurl {
    url = "http://old.files.sagemath.org/src-old/${name}.tar.gz";
    sha256 = "102mrzzi215g1xn5zgcv501x9sghwg758jagx2jixvg1rj2jijj9";

  };

  buildInputs = [ m4 perl gfortran texlive.combined.scheme-basic ffmpeg gnused_422 tk imagemagick liblapack
                  python openssl libpng which ];

  patches = [ ./spkg-singular.patch ./spkg-python.patch ./spkg-git.patch ];

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  preConfigure = ''
    export SAGE_NUM_THREADS=$NIX_BUILD_CORES
    export SAGE_ATLAS_ARCH=fast
    mkdir -p $out/sageHome
    export HOME=$out/sageHome
    export CPPFLAGS="-P"
  '';

  preBuild = "patchShebangs build";

  installPhase = ''DESTDIR=$out make install'';

  meta = {
    homepage = http://www.sagemath.org;
    description = "A free open source mathematics software system";
    license = stdenv.lib.licenses.gpl2Plus;
    broken = true;
  };
}
