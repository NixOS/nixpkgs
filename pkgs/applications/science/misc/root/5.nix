{ stdenv, fetchurl, cmake, pcre, pkgconfig, python2
, libX11, libXpm, libXft, libXext, libGLU_combined, zlib, libxml2, lzma, gsl_1
, Cocoa, OpenGL, cf-private, noSplash ? false }:

stdenv.mkDerivation rec {
  name = "root-${version}";
  version = "5.34.36";

  src = fetchurl {
    url = "https://root.cern.ch/download/root_v${version}.source.tar.gz";
    sha256 = "1kbx1jxc0i5xfghpybk8927a0wamxyayij9c74zlqm0595gqx1pw";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake pcre python2 zlib libxml2 lzma gsl_1 ]
    ++ stdenv.lib.optionals (!stdenv.isDarwin) [ libX11 libXpm libXft libXext libGLU_combined ]
    ++ stdenv.lib.optionals (stdenv.isDarwin) [ Cocoa OpenGL cf-private ]
    ;

  patches = [
    ./sw_vers_root5.patch
  ];

  preConfigure = ''
    patchShebangs build/unix/
    ln -s ${stdenv.lib.getDev stdenv.cc.libc}/include/AvailabilityMacros.h cint/cint/include/
  '' + stdenv.lib.optionalString noSplash ''
    substituteInPlace rootx/src/rootx.cxx --replace "gNoLogo = false" "gNoLogo = true"
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
    "-Dgfal=OFF"
    "-Dgsl_shared=ON"
    "-Dgviz=OFF"
    "-Dhdfs=OFF"
    "-Dkrb5=OFF"
    "-Dldap=OFF"
    "-Dmathmore=ON"
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
  ++ stdenv.lib.optional stdenv.isDarwin "-DOPENGL_INCLUDE_DIR=${OpenGL}/Library/Frameworks";

  enableParallelBuilding = true;

  setupHook = ./setup-hook.sh;

  meta = with stdenv.lib; {
    homepage = https://root.cern.ch/;
    description = "A data analysis framework";
    platforms = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
    # needs to be adapted to work with modern glibc
    # it works on darwin by impurely picking up system's libc headers
    broken = stdenv.isLinux;
  };
}
