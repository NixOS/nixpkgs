{ stdenv, python3, pkgconfig, which, libtool, autoconf, automake,
  autogen, sqlite, gmp, zlib, fetchurl, unzip, fetchpatch }:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "clightning";
  version = "0.7.2.1";

  src = fetchurl {
    url = "https://github.com/ElementsProject/lightning/releases/download/v${version}/clightning-v${version}.zip";
    sha256 = "3be716948efc1208b5e6a41e3034e4e4eecc5abbdac769fd1d999a104ac3a2ec";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoconf autogen automake libtool pkgconfig which unzip ];
  buildInputs =
    let py3 = python3.withPackages (p: [ p.Mako ]);
    in [ sqlite gmp zlib py3 ];

  makeFlags = [ "prefix=$(out) VERSION=v${version}" ];

  configurePhase = ''
    ./configure --prefix=$out --disable-developer --disable-valgrind
  '';

  postPatch = ''
    patchShebangs \
      tools/generate-wire.py \
      tools/update-mocks.sh \
      tools/mockup.sh
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
