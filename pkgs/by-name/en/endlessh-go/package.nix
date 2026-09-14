{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "endlessh-go";
  version = "2026.0730.0";

  src = fetchFromGitHub {
    owner = "shizunge";
    repo = "endlessh-go";
    rev = finalAttrs.version;
    hash = "sha256-jNU8PWKFhOl4cFHaKfypsOt8tWoVr2rymR8tVYxnxgc=";
  };

  vendorHash = "sha256-bJ7EaD0BQKQCww7ZLCz5Fqi8dy1w9RhRxwKGBQEEkN0=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.tests = {
    inherit (nixosTests) endlessh-go;
  };

  meta = {
    description = "Implementation of endlessh exporting Prometheus metrics";
    homepage = "https://github.com/shizunge/endlessh-go";
    changelog = "https://github.com/shizunge/endlessh-go/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "endlessh-go";
  };
})
