{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "container2wasm";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "container2wasm";
    repo = "container2wasm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-epugPyDvvY/HypGuwlx5mds8zCsilySNLwmHJ1H0Q4k=";
  };

  vendorHash = "sha256-/14U3SeZc5U1EJP6MbvOpR0wiFT7aPXKoI6OX2G4rNY=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/container2wasm/container2wasm/version.Version=${finalAttrs.version}"
  ];

  subPackages = [
    "cmd/c2w"
  ];

  meta = {
    description = "Container to WASM converter";
    homepage = "https://github.com/container2wasm/container2wasm";
    changelog = "https://github.com/container2wasm/container2wasm/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "c2w";
  };
})
