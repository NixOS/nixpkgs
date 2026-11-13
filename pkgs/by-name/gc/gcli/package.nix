{
  lib,
  fetchFromSourcehut,
  stdenv,
  curl,
  pkg-config,
  byacc,
  flex,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gcli";
  version = "2.14.0";

  src = fetchFromSourcehut {
    owner = "~herrhotzenplotz";
    repo = "gcli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cmhoVABA0WLUQALi1ILy+heY4hKF+6uTVdZIFz3EZas=";
  };

  nativeBuildInputs = [
    pkg-config
    byacc
    flex
  ];
  buildInputs = [ curl ];

  meta = {
    description = "Portable Git(Hub|Lab|ea) CLI tool";
    homepage = "https://herrhotzenplotz.de/gcli/";
    changelog = "https://git.sr.ht/~herrhotzenplotz/gcli/tree/v${finalAttrs.version}/item/Changelog.md";
    license = lib.licenses.bsd2;
    mainProgram = "gcli";
    maintainers = with lib.maintainers; [ kenran ];
    platforms = lib.platforms.unix;
  };
})
