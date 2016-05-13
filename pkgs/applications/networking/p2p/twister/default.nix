{ stdenv, fetchurl, autoconf, automake, libtool, pkgconfig, python
, boost, db, openssl, geoip, libiconv, miniupnpc
, srcOnly, fetchgit
}:

let
  twisterHTML = srcOnly {
    name = "twister-html";
    src = fetchgit {
      url = "git://github.com/miguelfreitas/twister-html.git";
      rev = "01e7f7ca9b7e42ed90f91bc42da2c909ca5c0b9b";
      sha256 = "0scjbin6s1kmi0bqq0dx0qyjw4n5xgmj567n0156i39f9h0dabqy";
    };
  };

in stdenv.mkDerivation rec {
  name = "twister-${version}";
  version = "0.9.30";

  src = fetchurl {
    url = "https://github.com/miguelfreitas/twister-core/"
        + "archive/v${version}.tar.gz";
    sha256 = "1i39iqq6z25rh869vi5k76g84rmyh30p05xid7z9sqjrqdfpyyzk";
  };

  configureFlags = [
    "--with-libgeoip"
    "--with-libiconv"
    "--disable-deprecated-functions"
    "--enable-tests"
    "--enable-python-binding"
    "--with-boost-libdir=${boost.out}/lib"
  ];

  buildInputs = [
    autoconf automake libtool pkgconfig python
    boost db openssl geoip miniupnpc libiconv
  ];

  postPatch = ''
    sed -i -e '/-htmldir/s|(default: [^)]*)|(default: ${twisterHTML})|' \
      src/init.cpp
    sed -i -e '/GetDataDir.*html/s|path *= *[^;]*|path = "${twisterHTML}"|' \
      src/util.cpp
  '';

  preConfigure = ''
    sh autotool.sh
  '';

  installPhase = ''
    install -vD twisterd "$out/bin/twisterd"
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "http://www.twister.net.co/";
    description = "Peer-to-peer microblogging";
    license = stdenv.lib.licenses.mit;
  };
}
