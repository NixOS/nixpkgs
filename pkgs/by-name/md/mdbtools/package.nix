{
  stdenv,
  lib,
  fetchFromGitHub,
  glib,
  readline,
  bison,
  flex,
  pkg-config,
  autoreconfHook,
  txt2man,
  which,
  withLibiodbc ? false,
  libiodbc,
  withUnixODBC ? true,
  unixODBC,
}:

stdenv.mkDerivation rec {
  pname = "mdbtools";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "mdbtools";
    repo = "mdbtools";
    rev = "v${version}";
    sha256 = "sha256-XWkFgQZKx9/pjVNEqfp9BwgR7w3fVxQ/bkJEYUvCXPs=";
  };

  configureFlags =
    [ "--disable-scrollkeeper" ]
    ++ lib.optional withUnixODBC "--with-unixodbc=${unixODBC}"
    ++ lib.optional withLibiodbc "--with-iodbc=${libiodbc}";

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=unused-but-set-variable";

  nativeBuildInputs =
    [
      pkg-config
      bison
      flex
      autoreconfHook
      txt2man
      which
    ]
    ++ lib.optional withLibiodbc libiodbc
    ++ lib.optional withUnixODBC unixODBC;

  buildInputs = [
    glib
    readline
  ];

  enableParallelBuilding = true;

  passthru = lib.optionalAttrs withUnixODBC {
    fancyName = "MDBTools";
    driver = "lib/odbc/libmdbodbc.so";
  };

  meta = with lib; {
    description = ".mdb (MS Access) format tools";
    license = with licenses; [
      gpl2Plus
      lgpl2
    ];
    maintainers = with lib.maintainers; [ geoffreyfrogeye ];
    platforms = platforms.unix;
    inherit (src.meta) homepage;
  };
}
