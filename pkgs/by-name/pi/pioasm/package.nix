{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pioasm";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "pico-sdk";
    rev = finalAttrs.version;
    hash = "sha256-epO7yw6/21/ess3vMCkXvXEqAn6/4613zmH/hbaBbUw=";
  };

  patches = [
    # Pull upstream fix for gcc-15:
    #   https://github.com/raspberrypi/pico-sdk/pull/2468
    (fetchpatch {
      name = "gcc-15.patch";
      url = "https://github.com/raspberrypi/pico-sdk/commit/66540fe88e86a9f324422b7451a3b5dff4c0449f.patch";
      hash = "sha256-KwTED7/IWorgRTw1XMU2ILJhf6DAioGuVIunlC1QdNE=";
      stripLen = 2;
    })
  ];

  sourceRoot = "${finalAttrs.src.name}/tools/pioasm";

  nativeBuildInputs = [
    cmake
    ninja
  ];

  installPhase = ''
    runHook preInstall

    install -D pioasm $out/bin/pioasm

    runHook postInstall
  '';

  meta = {
    description = "Assemble PIO programs for Raspberry Pi Pico";
    homepage = "https://github.com/raspberrypi/pico-sdk";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ emilytrau ];
    platforms = lib.platforms.unix;
    mainProgram = "pioasm";
  };
})
