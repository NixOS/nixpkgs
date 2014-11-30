{ stdenv, fetchurl, db4, boost, openssl, miniupnpc, unzip }:

with stdenv.lib;
stdenv.mkDerivation rec {
  version = "0.3.76";
  name = "namecoind-${version}";

  src = fetchurl {
    url = "https://github.com/namecoin/namecoin/archive/nc${version}.tar.gz";
    sha256 = "007372j47hb7p89smh3w0p6z70gii9gd4v6agpycqiv4r3n9sv5v";
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
