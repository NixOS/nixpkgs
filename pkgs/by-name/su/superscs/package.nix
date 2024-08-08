{
  blas,
  lapack,
  lib,
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "superscs";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "kul-optec";
    repo = "superscs";
    #rev = "v${finalAttrs.version}";
    # ref. https://github.com/kul-optec/superscs/pull/38
    rev = "500070e807f92347a7c6cbdc96739521a256b71e";
    hash = "sha256-Qu7RM6Ew4hEmoIXO0utDDVmjmNX3yt3FxWZXCQ/Xjp4=";
  };

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile --replace-fail \
      ".so" \
      ".dylib"
  '';

  buildInputs = [
    blas
    lapack
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = true;

  meta = {
    description = "Fast conic optimization in C";
    homepage = "https://github.com/kul-optec/superscs";
    changelog = "https://github.com/kul-optec/superscs/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
