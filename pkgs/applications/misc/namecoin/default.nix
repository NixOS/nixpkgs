{ fetchgit, stdenv, db4, boost, openssl, unzip }:

stdenv.mkDerivation rec {
  version = "0.3.76";
  name = "namecoin-${version}";

  src = fetchgit {
    url = "https://github.com/namecoin/namecoin";
    rev = "224175ca3bba6eea6f6b1bdb007b482eb2bd2aee";
    sha256 = "3ccfb6fdda1b9d105e775eb19c696be7fec1b3671f9b4f43d02fa14a4c6848dd";
  };

  # Don't build with miniupnpc due to namecoin using a different verison that
  # ships with NixOS and it is API incompatible.
  buildInputs = [ db4 boost boost.lib openssl unzip ];

  patchPhase = ''
    sed -e 's/-Wl,-Bstatic//g' -e 's/-l gthread-2.0//g' -e 's/-l z//g' -i src/Makefile
  '';

  buildPhase = ''
    make -C src INCLUDEPATHS= LIBPATHS=
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp src/namecoind $out/bin
  '';

  meta = {
    description = "Decentralized open source information registration and transfer system based on the Bitcoin cryptocurrency";
    homepage = "http://namecoin.info";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.doublec ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
