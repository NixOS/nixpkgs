{
  lib,
  fetchFromGitHub,
  buildGoModule,
  pkg-config,
  portaudio,
}:
buildGoModule (finalAttrs: {
  pname = "gostringsynth";
  version = "0-unstable-2022-03-10";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "crnbaker";
    repo = "gostringsynth";
    rev = "17a3ff88f78d8d2a5059c96294afb1470a4e09a6";
    hash = "sha256-YtKUCNPIulmzuEt+9lG8LtJJADCcGGoszXSSSwWFjNI=";
  };

  vendorHash = "sha256-5PvlF03kWn0gLmh+XfFMBOg8x/oLDPuwa++MVA1+OQs=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    portaudio
  ];

  meta = {
    description = "Real-time, polyphonic physical-modelling synthesizer that simulates the vibration of strings";
    homepage = "https://github.com/crnbaker/gostringsynth";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    mainProgram = "gostringsynth";
  };
})
