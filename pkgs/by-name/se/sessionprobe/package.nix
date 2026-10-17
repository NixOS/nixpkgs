{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "sessionprobe";
  version = "1.0.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dub-flow";
    repo = "sessionprobe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D31H/PnRtYqnBCIQOyuTstETAGNRDL79CCZFFW1D2jM=";
  };

  vendorHash = "sha256-3aE1uGOxMTbYTHOcgCuTi5JNPBVTgLeI+Gdt8yS50sg=";

  ldflags = [
    "-s"
    "-X=main.AppVersion=${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script { };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Tool for evaluating user privileges in web applications";
    homepage = "https://github.com/dub-flow/sessionprobe";
    changelog = "https://github.com/dub-flow/sessionprobe/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "sessionprobe";
  };
})
