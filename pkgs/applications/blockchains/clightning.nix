{ lib, stdenv, python3, pkg-config, which, libtool, autoconf, automake,
  autogen, sqlite, gmp, zlib, fetchurl, unzip, fetchpatch, gettext }:

with lib;
stdenv.mkDerivation rec {
  pname = "clightning";
  version = "0.9.2";

  src = fetchurl {
    url = "https://github.com/ElementsProject/lightning/releases/download/v${version}/clightning-v${version}.zip";
    sha256 = "022fw6rbn0chg0432h9q05w8qnys0hd9hf1qm2qlnnmamxw4dyfy";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoconf autogen automake libtool pkg-config which unzip gettext ];
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
      tools/mockup.sh \
      devtools/sql-rewrite.py
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
    homepage = "https://github.com/ElementsProject/lightning";
    maintainers = with maintainers; [ jb55 ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
