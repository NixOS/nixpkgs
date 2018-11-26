{ stdenv, python3, pkgconfig, which, libtool, autoconf, automake,
  autogen, sqlite, gmp, zlib, fetchFromGitHub, fetchpatch }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "clightning-${version}";
  version = "0.6.2";

  src = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "ElementsProject";
    repo = "lightning";
    rev = "v${version}";
    sha256 = "18yns0yyf7kc4p4n1crxdqh37j9faxkx216nh2ip7cxj4x8bf9gx";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoconf autogen automake libtool pkgconfig which ];
  buildInputs = [ sqlite gmp zlib python3 ];

  makeFlags = [ "prefix=$(out)" ];

  configurePhase = ''
    ./configure --prefix=$out --disable-developer --disable-valgrind
  '';

  # NOTE: remove me in 0.6.3
  patches = [
    (fetchpatch {
      name = "clightning_0_6_2-compile-error.patch";
      url = https://patch-diff.githubusercontent.com/raw/ElementsProject/lightning/pull/2070.patch;
      sha256 = "1576fqik5zcpz5zsvp2ks939bgiz0jc22yf24iv61000dd5j6na9";
    })
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
