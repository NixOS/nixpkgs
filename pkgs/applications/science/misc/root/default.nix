{ stdenv, fetchurl, fetchpatch, cmake, pcre, pkgconfig, python2
, libX11, libXpm, libXft, libXext, mesa, zlib, libxml2, lzma, gsl
, Cocoa, OpenGL }:

stdenv.mkDerivation rec {
  name = "root-${version}";
  version = "6.10.02";

  src = fetchurl {
    url = "https://root.cern.ch/download/root_v${version}.source.tar.gz";
    sha256 = "1ryp9397xpbnxha6s222c10pa50lf2qf5s35n31lc29s90p8s9kc";
  };

  buildInputs = [ cmake pcre pkgconfig python2 zlib libxml2 lzma gsl ]
    ++ stdenv.lib.optionals (!stdenv.isDarwin) [ libX11 libXpm libXft libXext mesa ]
    ++ stdenv.lib.optionals (stdenv.isDarwin) [ Cocoa OpenGL ]
    ;

  patches = [
    ./sw_vers.patch

    # this prevents thisroot.sh from setting $p, which interferes with stdenv setup
    ./thisroot.patch

    # https://sft.its.cern.ch/jira/browse/ROOT-8728
    ./ROOT-8728-extra.patch
  ];

  preConfigure = ''
    patchShebangs build/unix/
  '';

  cmakeFlags = [
    "-Drpath=ON"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-Dalien=OFF"
    "-Dbonjour=OFF"
    "-Dcastor=OFF"
    "-Dchirp=OFF"
    "-Ddavix=OFF"
    "-Ddcache=OFF"
    "-Dfftw3=OFF"
    "-Dfitsio=OFF"
    "-Dfortran=OFF"
    "-Dimt=OFF"
    "-Dgfal=OFF"
    "-Dgviz=OFF"
    "-Dhdfs=OFF"
    "-Dkrb5=OFF"
    "-Dldap=OFF"
    "-Dmonalisa=OFF"
    "-Dmysql=OFF"
    "-Dodbc=OFF"
    "-Dopengl=ON"
    "-Doracle=OFF"
    "-Dpgsql=OFF"
    "-Dpythia6=OFF"
    "-Dpythia8=OFF"
    "-Drfio=OFF"
    "-Dsqlite=OFF"
    "-Dssl=OFF"
    "-Dxml=ON"
    "-Dxrootd=OFF"
  ]
  ++ stdenv.lib.optional (stdenv.cc.libc != null) "-DC_INCLUDE_DIRS=${stdenv.lib.getDev stdenv.cc.libc}/include"
  ++ stdenv.lib.optional stdenv.isDarwin "-DOPENGL_INCLUDE_DIR=${OpenGL}/Library/Frameworks";

  enableParallelBuilding = true;

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = "https://root.cern.ch/";
    description = "A data analysis framework";
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
