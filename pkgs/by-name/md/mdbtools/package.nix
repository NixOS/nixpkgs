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

  configureFlags = [ "--disable-scrollkeeper" ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=unused-but-set-variable";

  nativeBuildInputs = [
    pkg-config
    bison
    flex
    autoreconfHook
    txt2man
    which
  ];

  buildInputs = [
    glib
    readline
  ];

  enableParallelBuilding = true;

  meta = {
    description = ".mdb (MS Access) format tools";
    license = with lib.licenses; [
      gpl2Plus
      lgpl2
    ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
    inherit (src.meta) homepage;
  };
}
