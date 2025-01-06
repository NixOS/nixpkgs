{
  lib,
  fetchFromGitHub,
  stdenv,
  curl,
  autoreconfHook,
  pkg-config,
  byacc,
  flex,
}:

stdenv.mkDerivation rec {
  pname = "gcli";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "herrhotzenplotz";
    repo = "gcli";
    rev = version;
    hash = "sha256-extVTaTWVFXSTiXlZ/MtiiFdc/KZEDkc+A7xxylJaM4=";
  };

  nativeBuildInputs = [
    autoreconfHook
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
