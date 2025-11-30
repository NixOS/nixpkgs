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
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "herrhotzenplotz";
    repo = "gcli";
    rev = "v${version}";
    hash = "sha256-Y6wAGg32ZnPAoFB9uzkPyeSAWATHpkBvNASZQ8S+SYc=";
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
