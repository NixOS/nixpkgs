{ lib
, stdenv
, fetchurl
, autoconf
, automake
, autogen
, gettext
, libtool
, pkg-config
, unzip
, which
, gmp
, libsodium
, python3
, sqlite
, zlib
}:
let
  py3 = python3.withPackages (p: [ p.Mako ]);
in
stdenv.mkDerivation rec {
  pname = "clightning";
  version = "0.10.1";

  src = fetchurl {
    url = "https://github.com/ElementsProject/lightning/releases/download/v${version}/clightning-v${version}.zip";
    sha256 = "9271e9e89d60332b66afedbf8d6eab2a4a488782ab400ee1f60667d73c5a9a96";
  };

  nativeBuildInputs = [ autogen autoconf automake gettext libtool pkg-config py3 unzip which ];

  buildInputs = [ gmp libsodium sqlite zlib ];

  postPatch = ''
    patchShebangs \
      tools/generate-wire.py \
      tools/update-mocks.sh \
      tools/mockup.sh \
      devtools/sql-rewrite.py
  '';

  configurePhase = ''
    ./configure --prefix=$out --disable-developer --disable-valgrind
  '';

  makeFlags = [ "prefix=$(out) VERSION=v${version}" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A Bitcoin Lightning Network implementation in C";
    longDescription = ''
      c-lightning is a standard compliant implementation of the Lightning
      Network protocol. The Lightning Network is a scalability solution for
      Bitcoin, enabling secure and instant transfer of funds between any two
      parties for any amount.
    '';
    homepage = "https://github.com/ElementsProject/lightning";
    maintainers = with maintainers; [ jb55 prusnak ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
