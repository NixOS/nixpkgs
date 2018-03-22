{ stdenv, fetchurl, fetchpatch, autoconf, automake, libtool, pkgconfig, python2
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
  version = "0.9.34";

  src = fetchurl {
    url = "https://github.com/miguelfreitas/twister-core/"
        + "archive/v${version}.tar.gz";
    sha256 = "1bi8libivd9y2bn9fc7vbc5q0jnal0pykpzgri6anqaww22y58jq";
  };

  configureFlags = [
    "--with-libgeoip"
    "--with-libiconv"
    "--disable-deprecated-functions"
    "--enable-tests"
    "--enable-python-binding"
    "--with-boost-libdir=${boost.out}/lib"
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    autoconf automake libtool python2
    boost db openssl geoip miniupnpc libiconv
  ];

  patches = stdenv.lib.singleton (fetchpatch {
    url = "https://github.com/miguelfreitas/twister-core/commit/"
        + "dd4f5a176958ea6ed855dc3fcef79680c1c0c92c.patch";
    sha256 = "06fgmqnjyl83civ3ixiq673k8zjgm8n2w4w46nsh810nprqim8s6";
  });

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
    homepage = http://www.twister.net.co/;
    description = "Peer-to-peer microblogging";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
  };
}
