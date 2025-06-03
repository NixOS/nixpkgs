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
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "herrhotzenplotz";
    repo = "gcli";
    rev = "v${version}";
    hash = "sha256-s71RImg/N8v9h472upI94Pae/Zlw27f4Kc9SCavP1oY=";
  };

  nativeBuildInputs = [
    pkg-config
    byacc
    flex
  ];
  buildInputs = [ curl ];

  meta = with lib; {
    description = "Portable Git(Hub|Lab|ea) CLI tool";
    homepage = "https://herrhotzenplotz.de/gcli/";
    changelog = "https://github.com/herrhotzenplotz/gcli/releases/tag/${version}";
    license = licenses.bsd2;
    mainProgram = "gcli";
    maintainers = with maintainers; [ kenran ];
    platforms = platforms.unix;
  };
}
