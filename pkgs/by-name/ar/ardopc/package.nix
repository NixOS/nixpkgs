{
  fetchFromGitHub,
  lib,
  makeWrapper,
  pkg-config,
  stdenv,
  alsa-lib,
  flrig,
  hamlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ardopc";
  version = "unstable-2021-08-28";

  src = fetchFromGitHub {
    owner = "hamarituc";
    repo = "ardop";
    tag = "20210828";
    hash = "sha256-OUw9spFTsQLnsXksbfl3wD2NyY40JTyvlvONEIeZyWo=";
  };

  sourceRoot = "${finalAttrs.src.name}/ARDOPC";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    flrig
    hamlib
  ];

  installPhase = ''
    runHook preInstall

    install -D ardopc $out/bin/ardopc

    runHook postInstall
  '';

  meta = {
    description = "ARDOP (Amateur Radio Digital Open Protocol) TNC implementation by John Wiseman (GM8BPQ)";
    homepage = "https://github.com/hamarituc/ardop/ARDOPC";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ oliver-koss ];
    mainProgram = "ardopc";
    platforms = lib.platforms.all;
  };
})
