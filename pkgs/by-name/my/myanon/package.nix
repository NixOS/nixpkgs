{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  flex,
  bison,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "myanon";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "ppomes";
    repo = "myanon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wMsrJnuO4njVeIIYCyVISEtqyrecwnEEg4dtaq9gdLI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    flex
    bison
    pkg-config
  ];

  meta = {
    description = "mysqldump anonymizer, reading a dump from stdin, and producing on the fly an anonymized version to stdout";
    homepage = "https://ppomes.github.io/myanon/";
    license = lib.licenses.bsd3;
    mainProgram = "myanon";
    platforms = lib.platforms.unix;
  };
})
