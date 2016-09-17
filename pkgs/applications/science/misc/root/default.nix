{ stdenv, fetchurl, fetchpatch, cmake, pcre, pkgconfig, python
, libX11, libXpm, libXft, libXext, zlib, lzma, gsl, Cocoa }:

stdenv.mkDerivation rec {
  name = "root-${version}";
  version = "6.04.18";

  src = fetchurl {
    url = "https://root.cern.ch/download/root_v${version}.source.tar.gz";
    sha256 = "00f3v3l8nimfkcxpn9qpyh3h23na0mi4wkds2y5gwqh8wh3jryq9";
  };

  buildInputs = [ cmake pcre pkgconfig python zlib lzma gsl ]
    ++ stdenv.lib.optionals (!stdenv.isDarwin) [ libX11 libXpm libXft libXext ]
    ++ stdenv.lib.optionals (stdenv.isDarwin) [ Cocoa ]
    ;

  patches = [
    (fetchpatch {
      url = "https://github.com/root-mirror/root/commit/ee9964210c56e7c1868618a4434c5340fef38fe4.patch";
      sha256 = "186i7ni75yvjydy6lpmaplqxfb5z2019bgpbhff1n6zn2qlrff2r";
    })
    ./sw_vers.patch
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
    "-Dgfal=OFF"
    "-Dgviz=OFF"
    "-Dhdfs=OFF"
    "-Dkrb5=OFF"
    "-Dldap=OFF"
    "-Dmonalisa=OFF"
    "-Dmysql=OFF"
    "-Dodbc=OFF"
    "-Dopengl=OFF"
    "-Doracle=OFF"
    "-Dpgsql=OFF"
    "-Dpythia6=OFF"
    "-Dpythia8=OFF"
    "-Drfio=OFF"
    "-Dsqlite=OFF"
    "-Dssl=OFF"
    "-Dxml=OFF"
    "-Dxrootd=OFF"
  ]
  ++ stdenv.lib.optional (stdenv.cc.libc != null) "-DC_INCLUDE_DIRS=${stdenv.lib.getDev stdenv.cc.libc}/include";

  enableParallelBuilding = true;

  meta = {
    homepage = "https://root.cern.ch/";
    description = "A data analysis framework";
    platforms = stdenv.lib.platforms.unix;
  };
}
