{ lib, stdenv, fetchFromGitHub, fetchpatch, autoconf, automake, libtool, pkg-config, python2
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

  boostPython = boost.override {
    enablePython = true;
    python = python2;
  };

in stdenv.mkDerivation rec {
  pname = "twister";
  version = "2019-08-19";

  src = fetchFromGitHub {
    owner = "miguelfreitas";
    repo = "twister-core";
    rev = "31faf3f63e461ea0a9b23081567a4a552cf06873";
    sha256 = "0xh1lgnl9nd86jr0mp7m8bkd7r5j4d6chd0y73h2xv4aq5sld0sp";
  };

  configureFlags = [
    "--with-libgeoip"
    "--with-libiconv"
    "--disable-deprecated-functions"
    "--enable-tests"
    "--enable-python-binding"
    "--with-boost-libdir=${boostPython.out}/lib"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    autoconf automake libtool python2
    boostPython db openssl geoip miniupnpc libiconv
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
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
