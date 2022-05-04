{ lib
, stdenv
, darwin
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
  py3 = python3.withPackages (p: [ p.Mako p.mrkd ]);
in
stdenv.mkDerivation rec {
  pname = "clightning";
  version = "0.11.0.1";

  src = fetchurl {
    url = "https://github.com/ElementsProject/lightning/releases/download/v${version}/clightning-v${version}.zip";
    sha256 = "e2ad6eead19a0cd8869e291c27d318cf553bb015339c1f0e8d8b30e7bc0910d8";
  };

  # when building on darwin we need dawin.cctools to provide the correct libtool
  # as libwally-core detects the host as darwin and tries to add the -static
  # option to libtool, also we have to add the modified gsed package.
  nativeBuildInputs = [ autogen autoconf automake gettext pkg-config py3 unzip which ]
    ++ lib.optionals stdenv.isDarwin [ darwin.cctools darwin.autoSignDarwinBinariesHook ] ++ [ libtool ];

  buildInputs = [ gmp libsodium sqlite zlib ];

  # this causes some python trouble on a darwin host so we skip this step.
  # also we have to tell libwally-core to use sed instead of gsed.
  postPatch = if !stdenv.isDarwin then ''
    patchShebangs \
      tools/generate-wire.py \
      tools/update-mocks.sh \
      tools/mockup.sh \
      devtools/sql-rewrite.py
  '' else ''
    substituteInPlace external/libwally-core/tools/autogen.sh --replace gsed sed && \
    substituteInPlace external/libwally-core/configure.ac --replace gsed sed
  '';

  configureFlags = [ "--disable-developer" "--disable-valgrind" ];

  makeFlags = [ "VERSION=v${version}" ];

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
    platforms = platforms.linux ++ platforms.darwin;
  };
}
