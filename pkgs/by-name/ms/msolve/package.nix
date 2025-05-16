{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  flint3,
  gmp,
  mpfr,
  llvmPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "msolve";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "algebraic-solving";
    repo = "msolve";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0kqRnBJA5CwsLY/YWZXu2+y4aiZAQQYl30Qb3JX3zEo=";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs =
    [
      flint3
      gmp
      mpfr
    ]
    ++ lib.optionals stdenv.cc.isClang [
      llvmPackages.openmp
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
