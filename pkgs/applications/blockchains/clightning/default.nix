{ lib
, stdenv
, darwin
, fetchurl
, autoconf
, autogen
, automake
, gettext
, libtool
, protobuf
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
  version = "0.12.0";

  src = fetchurl {
    url = "https://github.com/ElementsProject/lightning/releases/download/v${version}/clightning-v${version}.zip";
    sha256 = "1ff400339db3d314b459e1a3e973f1213783e814faa21f2e1b18917693cabfd9";
  };

  manpages = fetchurl {
    url = "https://github.com/ElementsProject/lightning/releases/download/v${version}/clightning-v${version}-manpages.tar.xz";
    sha256 = "sha256-7EohXp0/gIJwlMsTHwlcLNBzZb8LwF9n0eXkQhOnY7g=";
  };

  # when building on darwin we need dawin.cctools to provide the correct libtool
  # as libwally-core detects the host as darwin and tries to add the -static
  # option to libtool, also we have to add the modified gsed package.
  nativeBuildInputs = [ autoconf autogen automake gettext libtool protobuf py3 unzip which ]
    ++ lib.optionals stdenv.isDarwin [ darwin.cctools darwin.autoSignDarwinBinariesHook ];

  buildInputs = [ gmp libsodium sqlite zlib ];

  postUnpack = ''
    tar -xf $manpages -C $sourceRoot
  '';

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
