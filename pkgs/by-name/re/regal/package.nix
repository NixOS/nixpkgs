{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  name = "regal";
  version = "0.33.1";

  src = fetchFromGitHub {
    owner = "StyraInc";
    repo = "regal";
    rev = "v${version}";
    hash = "sha256-4H2/qHJA+/a2yoFNHhVUAslsyetesGdDqA8jHWN8L7E=";
  };

  vendorHash = "sha256-JlbNTQYRGlmzoPP+mIEVjtObGNI1/uuseLz5trxN5gM=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/styrainc/regal/pkg/version.Version=${version}"
    "-X github.com/styrainc/regal/pkg/version.Commit=${version}"
  ];

  meta = with lib; {
    description = "Linter and language server for Rego";
    mainProgram = "regal";
    homepage = "https://github.com/StyraInc/regal";
    changelog = "https://github.com/StyraInc/regal/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ rinx ];
  };
}
