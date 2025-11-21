{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "redka";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "nalgeon";
    repo = "redka";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8p1riY5tCLhNWbXGmMEolqVVyjeKmc0WSaTI7lLZhJk=";
  };

  vendorHash = "sha256-vtCUDRBVbG7xocE7yUDktUSzEEc5af75R7rmcabu/sQ=";

  subPackages = [
    "cmd/redka"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  meta = {
    description = "Redis re-implemented with SQLite";
    homepage = "https://github.com/nalgeon/redka";
    changelog = "https://github.com/nalgeon/redka/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [ sikmir ];
    license = lib.licenses.bsd3;
  };
})
