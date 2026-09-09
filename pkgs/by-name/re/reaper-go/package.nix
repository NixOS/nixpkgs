{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "reaper-go";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "ghostsecurity";
    repo = "reaper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HPY0K+VC3XCYOMz+J1Nhz1+cNkbxCFeA161vblzE63M=";
  };

  vendorHash = "sha256-INK3esHVaUFrnCxd/U5s2AjYzUYDxI4OpFXskpzwOSU=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/ghostsecurity/reaper/version.Date=1970-01-01T00:00:00Z"
    "-X=github.com/ghostsecurity/reaper/version.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "Application security testing framework";
    homepage = "https://github.com/ghostsecurity/reaper";
    changelog = "https://github.com/ghostsecurity/reaper/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "reaper";
  };
})
