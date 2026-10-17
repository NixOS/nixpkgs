{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  flex,
  ncurses,
  readline,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cgdb";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "cgdb";
    repo = "cgdb";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-tkm4TmH4sl0ujerSdlt+jhRD6mNFsYMdqtiLh0r1BWo=";
  };

  patches = lib.optional (lib.versionOlder finalAttrs.version "0.8.1") ./gcc14.patch;

  buildInputs = [
    ncurses
    readline
  ];

  nativeBuildInputs = [
    autoreconfHook
    flex
    texinfo
  ];

  # Use autoreconfHook to replicate the steps ./autogen.sh takes
  autoreconfFlags = [
    "-I config"
    "--install"
    "--warnings=no-portability"
  ];

  # VERSION file must exist with the cgdb version
  preAutoreconf = ''
    export AUTOMAKE_FLAGS="--foreign --add-missing --copy"
    echo ${finalAttrs.version} > VERSION
  '';

  strictDeps = true;

  meta = {
    description = "Curses interface to gdb";
    mainProgram = "cgdb";

    homepage = "https://cgdb.github.io/";

    license = lib.licenses.gpl2Plus;

    platforms = with lib.platforms; linux ++ cygwin;
    maintainers = [ ];
  };
})
