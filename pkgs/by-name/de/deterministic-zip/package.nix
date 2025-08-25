{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "deterministic-zip";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "timo-reymann";
    repo = "deterministic-zip";
    rev = "refs/tags/${version}";
    hash = "sha256-zyQ91NoPBgbH4Ob6l3d2RflOpMWJcpo1LNvqHPzhMIw=";
  };

  vendorHash = "sha256-uarCXEeZsNc0qJK9Tukd5esa+3hCB45D3tS9XqkZ4hU=";

  ldflags = [
    "-s"
    "-X github.com/timo-reymann/deterministic-zip/pkg/buildinfo.GitSha=${src.rev}"
    "-X github.com/timo-reymann/deterministic-zip/pkg/buildinfo.Version=${version}"
  ];

  meta = {
    description = "Simple (almost drop-in) replacement for zip that produces deterministic files";
    mainProgram = "deterministic-zip";
    homepage = "https://github.com/timo-reymann/deterministic-zip";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ rhysmdnz ];
  };
}
