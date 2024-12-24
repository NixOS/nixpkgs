{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  flint,
  gmp,
  mpfr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "msolve";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "algebraic-solving";
    repo = "msolve";
    rev = "v${finalAttrs.version}";
    hash = "sha256-F4jEZ3+bA3FADiVZMDNE0T9kd1K1ZBInIaORqQtv+sY=";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    flint
    gmp
    mpfr
  ];

  doCheck = true;

  meta = {
    description = "Library for polynomial system solving through algebraic methods";
    mainProgram = "msolve";
    homepage = "https://msolve.lip6.fr";
    changelog = "https://github.com/algebraic-solving/msolve/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.unix;
  };
})
