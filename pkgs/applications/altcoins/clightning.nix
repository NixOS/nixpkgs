{ stdenv, python3, pkgconfig, which, libtool, autoconf, automake,
  autogen, sqlite, gmp, zlib, fetchzip }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "clightning-${version}";
  version = "0.6.3";

  src = fetchzip {
    #
    # NOTE 0.6.3 release zip was bugged, this zip is a fix provided by the team
    # https://github.com/ElementsProject/lightning/issues/2254#issuecomment-453791475
    #
    # replace url with:
    #   https://github.com/ElementsProject/lightning/releases/download/v${version}/clightning-v${version}.zip
    # for future relases
    #
    url = "https://github.com/ElementsProject/lightning/files/2752675/clightning-v0.6.3.zip";
    sha256 = "0k5pwimwn69pcakiq4a7qnjyf4i8w1jlacwrjazm1sfivr6nfiv6";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoconf autogen automake libtool pkgconfig which ];
  buildInputs = [ sqlite gmp zlib python3 ];

  makeFlags = [ "prefix=$(out) VERSION=v${version}" ];

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
