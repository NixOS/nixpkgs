{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "starcharts";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "starcharts";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+CP+9lWBL1u8d/7KAtIQunOVJSY30jgV0/mafNN3TWw=";
  };

  vendorHash = "sha256-9Z4meJHZeT/eF6WD25tP5CMGB7syxWWqHUTWrW03AME=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Plot your repository stars over time";
    mainProgram = "starcharts";
    homepage = "https://github.com/caarlos0/starcharts";
    changelog = "https://github.com/caarlos0/starcharts/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
