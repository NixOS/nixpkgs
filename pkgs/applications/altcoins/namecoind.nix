{ stdenv, fetchzip, db4, boost, openssl, miniupnpc, unzip }:

with stdenv.lib;
stdenv.mkDerivation rec {
  version = "0.3.80";
  name = "namecoind-${version}";

  src = fetchzip {
    url = "https://github.com/namecoin/namecoin/archive/nc${version}.tar.gz";
    sha256 = "0mbkhj7y3f4vbqp5q3zk27bzqlk2kq71rcgivvj06w29fzd64mw6";
  };

  buildInputs = [ db4 boost openssl unzip miniupnpc ];

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
    homepage = http://namecoin.info;
    license = licenses.mit;
    maintainers = with maintainers; [ doublec AndersonTorres ];
    platforms = platforms.linux;
  };
}
