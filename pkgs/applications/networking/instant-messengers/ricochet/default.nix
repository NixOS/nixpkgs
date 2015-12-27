{ stdenv, fetchurl, pkgconfig
, qtbase, qttools, makeQtWrapper
, qtmultimedia, qtquick1, qtquickcontrols
, openssl, protobuf
}:

stdenv.mkDerivation rec {
  name = "ricochet-${version}";
  version = "1.1.1";

  src = fetchurl {
    url = "https://github.com/ricochet-im/ricochet/archive/v${version}.tar.gz";
    sha256 = "0y79igzgl9xn00981zcyxdlks7vnqxhb4rq3x8gwxm0yr98p39ms";
  };

  buildInputs =
    [
      qtbase qttools qtmultimedia qtquick1 qtquickcontrols
      openssl protobuf
    ];

  nativeBuildInputs = [ pkgconfig makeQtWrapper ];

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags openssl)"
  '';

  configureScript = "qmake";
  dontAddPrefix = true;
  configureFlags = [ "PREFIX=$(out)" "DEFINES+=RICOCHET_NO_PORTABLE" ];

  installPhase = ''
    mkdir -p $out/bin
    cp ricochet $out/bin
    wrapQtProgram $out/bin/ricochet
  '';

  meta = with stdenv.lib; {
    description = "Anonymous peer-to-peer instant messaging";
    homepage = "https://ricochet.im";
    license = licenses.bsd3;
    maintainers = [ maintainers.codsl ];
  };
}
