{ fetchurl, stdenv, cmake, coin3d, xercesc, ode, eigen, qt4, opencascade, gts,
boost, zlib,
python, swig, gfortran, soqt, autoconf, automake, libtool }:

throw "It does not build still"

stdenv.mkDerivation rec {
  name = "freecad-${version}";
  version = "0.11.3729";

  src = fetchurl {
/*
    url = "mirror://sourceforge/free-cad/freecad-${version}.tar.gz";
    sha256 = "0q9jhnhkjsq9iy4kqi4xh2ljack4b2jj4pjm4dylv4z2d9gg5p4l";
*/
    url = "mirror://sourceforge/free-cad/freecad-${version}.dfsg.tar.gz";
    sha256 = "0sjcbadzzgdjr5bk51nr3nq0siyvfdq0913dqlhv9xr42vha3j8r";
  };

  buildInputs = [ cmake coin3d xercesc ode eigen qt4 opencascade gts boost
    zlib python swig gfortran soqt /*autoconf automake libtool*/ ];

/*
  # Using autotools
  patchPhase = ''
    sed -i -e 's/boost_\([a-z_]\+\)-mt/boost_\1/' \
      configure
  '';

  configureFlags = [ "--with-eigen2-include=${eigen}/include/eigen2"
    "--with-boost-include=${boost}/include"
    "--with-boost-lib=${boost}/lib"
    "--with-qt4-dir=${qt4}"
  ];
*/

  # Using cmake

  patchPhase = ''
    sed -i -e '/Idf/d' -e '/Start/d' src/Mod/CMakeLists.txt
  '';

  cmakeFlags = [ "-Wno-dev" ];

}
