{ stdenv, python3, pkgconfig, which, libtool, autoconf, automake,
  autogen, sqlite, gmp, zlib, fetchFromGitHub }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "clightning-${version}";
  version = "0.6.1";

  src = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "ElementsProject";
    repo = "lightning";
    rev = "v${version}";
    sha256 = "0qx30i1c97ic4ii8bm0sk9dh76nfg4ihl9381gxjj14i4jr1q8y4";
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
