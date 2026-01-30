{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "olm";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "olm";
    tag = version;
    hash = "sha256-k5l8l8nLI52oox1qUHEax8l939NyDum/RbwEYOgCDIc=";
  };

  vendorHash = "sha256-lqH/pMWeDsTJa39uJwHntCAUs0BwJiB0aMyFaI++5ms=";

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;

  meta = {
    description = "Tunneling client for Pangolin";
    homepage = "https://github.com/fosrl/olm";
    changelog = "https://github.com/fosrl/olm/releases/tag/${src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      jackr
      water-sucks
    ];
    mainProgram = "olm";
  };
}
