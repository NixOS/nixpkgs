{ stdenv, fetchurl, makeWrapper, cmake, gl2ps, gsl, libX11, libXpm, libXft
, libXext, libGLU, libGL, libxml2, lz4, lzma, pcre, pkgconfig, python, xxHash
, zlib
, Cocoa, OpenGL, noSplash ? false }:

stdenv.mkDerivation rec {
  pname = "root";
  version = "6.18.04";

  src = fetchurl {
    url = "https://root.cern.ch/download/root_v${version}.source.tar.gz";
    sha256 = "196ghma6g5a7sqz52wyjkgvmh4hj4vqwppm0zwdypy33hgy8anii";
  };

  nativeBuildInputs = [ makeWrapper cmake pkgconfig ];
  buildInputs = [ gl2ps pcre python zlib libxml2 lz4 lzma gsl xxHash ]
    ++ stdenv.lib.optionals (!stdenv.isDarwin) [ libX11 libXpm libXft libXext libGLU libGL ]
    ++ stdenv.lib.optionals (stdenv.isDarwin) [ Cocoa OpenGL ]
    ;
  propagatedBuildInputs = [ python.pkgs.numpy ];

  patches = [
    ./sw_vers.patch
  ];

  preConfigure = ''
    rm -rf builtins/*
    substituteInPlace cmake/modules/SearchInstalledSoftware.cmake \
      --replace 'set(lcgpackages ' '#set(lcgpackages '

    patchShebangs build/unix/
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
    "-Dclad=OFF"
    "-Ddavix=OFF"
    "-Ddcache=OFF"
    "-Dfail-on-missing=ON"
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
    "-Dvdt=OFF"
    "-Dxml=ON"
    "-Dxrootd=OFF"
  ]
  ++ stdenv.lib.optional (stdenv.cc.libc != null) "-DC_INCLUDE_DIRS=${stdenv.lib.getDev stdenv.cc.libc}/include"
  ++ stdenv.lib.optional stdenv.isDarwin "-DOPENGL_INCLUDE_DIR=${OpenGL}/Library/Frameworks";

  enableParallelBuilding = true;

  postInstall = ''
    for prog in rootbrowse rootcp rooteventselector rootls rootmkdir rootmv rootprint rootrm rootslimtree; do
      wrapProgram "$out/bin/$prog" \
        --prefix PYTHONPATH : "$out/lib"
    done
  '';

  setupHook = ./setup-hook.sh;

  meta = with stdenv.lib; {
    homepage = https://root.cern.ch/;
    description = "A data analysis framework";
    platforms = platforms.unix;
    maintainers = [ maintainers.veprbl ];
    license = licenses.lgpl21;
  };
}
