{
  lib,
  stdenv,
  fetchFromSourcehut,
  buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scdoc";
  version = "1.11.4";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "scdoc";
    rev = finalAttrs.version;
    hash = "sha256-gldCHzLigeLKDFDcE3TYrNOEWoSt/uYIg9aTg6wwW54=";
  };

  outputs = [
    "out"
    "man"
    "dev"
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "HOST_SCDOC=${lib.getExe buildPackages.scdoc}"
  ];

  doCheck = true;

  meta = {
    description = "Simple man page generator written in C99 for POSIX systems";
    homepage = "https://git.sr.ht/~sircmpwn/scdoc";
    changelog = "https://git.sr.ht/~sircmpwn/scdoc/refs/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    mainProgram = "scdoc";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
