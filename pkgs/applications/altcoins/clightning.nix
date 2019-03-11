{ stdenv, python3, pkgconfig, which, libtool, autoconf, automake,
  autogen, sqlite, gmp, zlib, fetchurl, unzip, fetchpatch }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "clightning-${version}";
  version = "0.7.0";

  src = fetchurl {
    url = "https://github.com/ElementsProject/lightning/releases/download/v${version}/clightning-v${version}.zip";
    sha256 = "448022c2433cbf19bbd0f726344b0500c0c21ee5cc2291edf6b622f094cb3a15";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoconf autogen automake libtool pkgconfig which unzip ];
  buildInputs = [ sqlite gmp zlib python3 ];

  makeFlags = [ "prefix=$(out) VERSION=v${version}" ];

  patches = [
    # remove after 0.7.0
    (fetchpatch {
      name = "fix-0.7.0-build.patch";
      url = "https://github.com/ElementsProject/lightning/commit/ffc03d2bc84dc42f745959fbb6c8007cf0a6f701.patch";
      sha256 = "1m5fiz3m8k3nk09nldii8ij94bg6fqllqgdbiwj3sy12vihs8c4v";
    })
  ];

  configurePhase = ''
    ./configure --prefix=$out --disable-developer --disable-valgrind
  '';

  postPatch = ''
    patchShebangs tools/generate-wire.py
  '';

  doCheck = false;

  meta = {
    description = "A Bitcoin Lightning Network implementation in C";
    longDescription= ''
      c-lightning is a standard compliant implementation of the Lightning
      Network protocol. The Lightning Network is a scalability solution for
      Bitcoin, enabling secure and instant transfer of funds between any two
      parties for any amount.
    '';
    homepage = https://github.com/ElementsProject/lightning;
    maintainers = with maintainers; [ jb55 ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
