{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  bc,
  check,
  curl,

  withEncryption ? true,
  libgcrypt,
  libgpg-error,

  withUuid ? true,
  libuuid,

  withBashBuiltins ? true,
  bash,
}:

stdenv.mkDerivation rec {
  pname = "recutils";
  version = "1.9";

  src = fetchurl {
    url = "mirror://gnu/recutils/recutils-${version}.tar.gz";
    hash = "sha256-YwFZKwAgwUtFZ1fvXUNNSfYCe45fOkmdEzYvIFxIbg4=";
  };

  patches = [
    (fetchpatch {
      name = "configure-big_sur.diff";
      url = "https://github.com/Homebrew/formula-patches/raw/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff";
      hash = "sha256-NazWrrwZhD8aKzpj6IC6zrD1J4qxrOZh5XpQLZ14yTw=";
    })
  ];

  hardeningDisable = lib.optional stdenv.cc.isClang "format";

  configureFlags = lib.optionals withBashBuiltins [
    "--with-bash-headers=${bash.dev}/include/bash"
  ];

  buildInputs = [
    curl
  ]
  ++ lib.optionals withEncryption [
    libgpg-error.dev
    libgcrypt.dev
  ]
  ++ lib.optionals withUuid [
    libuuid
  ]
  ++ lib.optionals withBashBuiltins [
    bash.dev
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [
      "-Wno-error=implicit-function-declaration"
    ]
    ++ lib.optionals stdenv.cc.isGNU [
      "-Wno-error=implicit-function-declaration"
      "-Wno-error=incompatible-pointer-types"
    ]
  );

  nativeCheckInputs = [
    bc
    check
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://www.gnu.org/software/recutils/";
    description = "Tools and libraries to access human-editable, text-based databases";
    longDescription = ''
      GNU Recutils is a set of tools and libraries to access human-editable,
      text-based databases called recfiles. The data is stored as a sequence of
      records, each record containing an arbitrary number of named fields.
    '';
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
