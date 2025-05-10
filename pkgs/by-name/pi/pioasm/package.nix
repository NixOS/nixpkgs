{
  lib,
  stdenv,
  fetchFromGitHub,
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

  meta = with lib; {
    description = "Assemble PIO programs for Raspberry Pi Pico";
    homepage = "https://github.com/raspberrypi/pico-sdk";
    license = licenses.bsd3;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.unix;
    mainProgram = "pioasm";
  };
})
