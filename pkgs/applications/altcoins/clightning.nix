{ stdenv, fetchpatch, python3, pkgconfig, which, libtool, autoconf, automake,
  autogen, git, sqlite, gmp, zlib, fetchFromGitHub }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "clightning-${version}";
  version = "0.6rc1";

  src = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "ElementsProject";
    repo = "lightning";
    rev = "v${version}";
    sha256 = "12ki7x4aydch6clhxd34lrn8cxzyfad7nd29hl86sws1rd9bj72b";
  };

  enableParallelBuilding = true;

  buildInputs = [ which sqlite gmp zlib autoconf libtool automake autogen python3 pkgconfig ];

  makeFlags = [ "prefix=$(out)" ];

  configurePhase = ''
    ./configure --prefix=$out --disable-developer --disable-valgrind
  '';

  # remove on 0.6 release
  patches = [ "${fetchpatch { url = https://github.com/ElementsProject/lightning/commit/d7aa0528b879447653f69a6eed372a6bd667aa6a.patch;
                              sha256 = "0rkb25imlnw3a82mdpg0486mxmhspzcayn8wr3mkzd38z7di50nf";
                            }}"
            ];

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
