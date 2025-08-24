{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:
let
  version = "0.16.7";
in
buildGoModule {
  pname = "heimdall-proxy";

  inherit version;

  src = fetchFromGitHub {
    owner = "dadrus";
    repo = "heimdall";
    tag = "v${version}";
    hash = "sha256-YFqaCXx/x2LfdqaJZFTGkK/k7qIRWKXA1t/KZeWLDGw=";
  };

  vendorHash = "sha256-E/tdRS96rPWZHwtG22TFB1p7CUaFsya7nI8cAEuYvJo=";

  tags = [ "sqlite" ];

  subPackages = [ "." ];

  env.CGO_ENABLED = 0;

  # Pass versioning information via ldflags
  ldflags = [
    "-s"
    "-w"
    "-X github.com/dadrus/heimdall/version.Version=${version}"
  ];

  meta = {
    description = "Cloud native Identity Aware Proxy and Access Control Decision service";
    homepage = "https://dadrus.github.io/heimdall";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ albertilagan ];
    mainProgram = "heimdall";
  };
}
