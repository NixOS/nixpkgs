{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "piko";
  version = "0.10.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "andydunstall";
    repo = "piko";
    tag = "v${version}";
    hash = "sha256-fOdPtPeUKHw0e//PrvqvwhjGpYB4C7x0tGJckVRBEkQ=";
  };

  vendorHash = "sha256-fDhG1YeuoAw+wkrPRUONW0Sb/aPzwFDMmLadOefxVsw=";

  ldflags = [
    "-X github.com/andydunstall/piko/pkg/build.Version=${version}"
  ];

  meta = {
    description = "Open-source alternative to Ngrok, designed to serve production traffic and be simple to host (particularly on Kubernetes)";
    homepage = "https://github.com/andydunstall/piko";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ echoz ];
    mainProgram = "piko";
  };
}
