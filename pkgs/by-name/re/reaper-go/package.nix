{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "reaper-go";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "ghostsecurity";
    repo = "reaper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZSHG4pQTo+Z05MvBqFoscMaZuezScTuszOF8hn4UZXs=";
  };

  vendorHash = "sha256-Kn/anDDHWfapWB/ZHu4MRmEQ7Nn8hjUMS+LWK9Dx/g4=";

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
