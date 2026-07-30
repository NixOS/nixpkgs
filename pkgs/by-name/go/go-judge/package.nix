{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "go-judge";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "criyle";
    repo = "go-judge";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QWLR0bIBgjqh75D0J7KEDjS+6rL5kV+fg01ThO6Cbq0=";
  };

  vendorHash = "sha256-i5RiLaALbHQhOSb143kyQQGu2maJIw2VS0JELmxbxM0=";

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
