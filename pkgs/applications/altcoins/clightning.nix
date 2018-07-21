{ stdenv, python3, pkgconfig, which, libtool, autoconf, automake,
  autogen, sqlite, gmp, zlib, fetchFromGitHub }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "clightning-${version}";
  version = "0.6";

  src = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "ElementsProject";
    repo = "lightning";
    rev = "v${version}";
    sha256 = "1xbi8c7kn21wj255fxnb9s0sqnzbn3wsz4p96z084k8mw1nc71vn";
  };

  enableParallelBuilding = true;

  buildInputs = [ which sqlite gmp zlib autoconf libtool automake autogen python3 pkgconfig ];

  makeFlags = [ "prefix=$(out)" ];

  configurePhase = ''
    ./configure --prefix=$out --disable-developer --disable-valgrind
  '';

  postPatch = ''
    echo "" > tools/refresh-submodules.sh
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
