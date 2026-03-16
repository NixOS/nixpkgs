{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "container2wasm";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "ktock";
    repo = "container2wasm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vmEof0mcvBau/eYtUj5DzzZm5QgkM3G6TsG8doLju78=";
  };

  vendorHash = "sha256-Lg8gvbnyEcrwDGPiHrB7NR4waB2/yqyQbZsp/pQK0jc=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/ktock/container2wasm/version.Version=${finalAttrs.version}"
  ];

  subPackages = [
    "cmd/c2w"
  ];

  meta = {
    description = "Container to WASM converter";
    homepage = "https://github.com/ktock/container2wasm";
    changelog = "https://github.com/ktock/container2wasm/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "c2w";
  };
})
