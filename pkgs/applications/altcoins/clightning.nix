{ stdenv, python3, pkgconfig, which, libtool, autoconf, automake,
  autogen, sqlite, gmp, zlib, fetchurl, unzip, fetchpatch }:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "clightning";
  version = "0.7.1";

  src = fetchurl {
    url = "https://github.com/ElementsProject/lightning/releases/download/v${version}/clightning-v${version}.zip";
    sha256 = "557be34410f27a8d55d9f31a40717a8f5e99829f2bd114c24e7ca1dd5f6b7d85";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoconf autogen automake libtool pkgconfig which unzip ];
  buildInputs = [ sqlite gmp zlib python3 ];

  makeFlags = [ "prefix=$(out) VERSION=v${version}" ];

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
