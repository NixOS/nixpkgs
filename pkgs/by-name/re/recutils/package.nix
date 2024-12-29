{
  lib,
  stdenv,
  fetchurl,
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

  hardeningDisable = lib.optional stdenv.cc.isClang "format";

  configureFlags = lib.optionals withBashBuiltins [
    "--with-bash-headers=${bash.dev}/include/bash"
  ];

  buildInputs =
    [
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
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.all;
  };
}
