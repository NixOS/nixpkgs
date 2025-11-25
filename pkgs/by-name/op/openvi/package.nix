{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  ncurses,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openvi";
  version = "7.7.32";

  src = fetchFromGitHub {
    owner = "johnsonjh";
    repo = "OpenVi";
    tag = finalAttrs.version;
    hash = "sha256-kLULaKEefMpNLANnVdWAZeH+2KY5gEWGce6vJ/R7HAI=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    perl
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    ncurses
  ];

  makeFlags = [
    "PREFIX=$(out)"
    # command -p will yield command not found error
    "PAWK=awk"
    # silently fail the chown command
    "IUSGR=$(USER)"
  ];

  # Don't include ncurses header, but link against ncurses
  # openvi requires GNU ncurses symbols, but ncurses headers
  # is incompatible with macOS wchar.h, resulting in
  # "error: expected function body after function declarator"
  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-L${lib.getLib ncurses}/lib -lncursesw";

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/johnsonjh/OpenVi";
    description = "Portable OpenBSD vi for UNIX systems";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ aleksana ];
    mainProgram = "ovi";
  };
})
