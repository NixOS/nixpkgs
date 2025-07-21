{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "reaper-go";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "ghostsecurity";
    repo = "reaper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NXRqKO76RoxEvR7slMmUDdesRFMxDJpX/IGxoTDwJVU=";
  };

  vendorHash = "sha256-PxZ+fx5wkYuggMfpTfkc8quSssCzXdIcwjdR4qhDbqE=";

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
