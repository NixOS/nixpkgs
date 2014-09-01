{ fetchgit, stdenv, db4, boost, openssl, unzip }:

stdenv.mkDerivation rec {
  version = "0.3.75";
  name = "namecoin-${version}";

  src = fetchgit {
    url = "https://github.com/namecoin/namecoin";
    rev = "31ea638d4ba7f0a3011cb25483f4c7d293134c7a";
    sha256 = "c14a5663cba675b3508937a26a812316559938fd7b64659dd00749a9f5d7e9e0";
  };

  # Don't build with miniupnpc due to namecoin using a different verison that
  # ships with NixOS and it is API incompatible.
  buildInputs = [ db4 boost openssl unzip ];

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
    license = "MIT";
    maintainers = [ "Chris Double <chris.double@double.co.nz>" ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
