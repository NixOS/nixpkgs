{ stdenv, fetchurl, autoconf, automake, libtool, pkgconfig, python
, boost, db, openssl, geoip, libiconv, miniupnpc
, srcOnly, fetchgit
}:

let
  twisterHTML = srcOnly {
    name = "twister-html";
    src = fetchgit {
      url = "git://github.com/miguelfreitas/twister-html.git";
      rev = "891f7bf24e1c3df7ec5e1db23c765df2d7c2d5a9";
      sha256 = "0d96rfkpwxyiz32k2pd6a64r2kr3600qgp9v73ddcpq593wf11qb";
    };
  };

in stdenv.mkDerivation rec {
  name = "twister-${version}";
  version = "0.9.22";

  src = fetchurl {
    url = "https://github.com/miguelfreitas/twister-core/"
        + "archive/v${version}.tar.gz";
    sha256 = "1haq0d7ypnazs599g4kcq1x914fslc04wazqj54rlvjdp7yx4j3f";
  };

  configureFlags = [
    "--with-libgeoip"
    "--with-libiconv"
    "--with-boost=${boost}"
    "--disable-deprecated-functions"
    "--enable-tests"
    "--enable-python-binding"
  ];

  buildInputs = [
    autoconf automake libtool pkgconfig python
    boost db openssl geoip libiconv miniupnpc
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
