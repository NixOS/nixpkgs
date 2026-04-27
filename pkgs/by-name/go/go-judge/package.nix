{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "go-judge";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "criyle";
    repo = "go-judge";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JxYdoDSkzb+BM76m+qzdLM31ox9jqCm3LDrjTn6q1/E=";
  };

  vendorHash = "sha256-7DwEATr5AZGXHJXwDxjLpERquXFYm3AYjU/g3v7Xmlw=";

  tags = [
    "nomsgpack"
    "grpcnotrace"
  ];

  subPackages = [ "cmd/go-judge" ];

  preBuild = ''
    echo v${finalAttrs.version} > ./cmd/go-judge/version/version.txt
  '';

  env.CGO_ENABLED = 0;

  meta = {
    description = "High performance sandbox service based on container technologies";
    homepage = "https://docs.goj.ac";
    license = lib.licenses.mit;
    mainProgram = "go-judge";
    maintainers = with lib.maintainers; [ criyle ];
  };
})
