{
  lib,
  fetchFromGitHub,
  stdenv,
  curl,
  pkg-config,
  byacc,
  flex,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "gcli";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "herrhotzenplotz";
    repo = "gcli";
    rev = "v${version}";
    hash = "sha256-2L6/ZYxRY2xrTxr/oD02xCRqdk7VWrPlFwr8wU8C2x8=";
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
    changelog = "https://github.com/herrhotzenplotz/gcli/releases/tag/${version}";
    license = lib.licenses.bsd2;
    mainProgram = "gcli";
    maintainers = with lib.maintainers; [ kenran ];
    platforms = lib.platforms.unix;
  };
}
