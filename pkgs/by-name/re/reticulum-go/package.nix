{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "reticulum-go";
  version = "0.9.5";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Quad4-Software";
    repo = "Reticulum-Go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LszknSPyZRE/uGy5jSmKAmi+oBargjN+AgbT8QJ3hug=";
  };

  vendorHash = null;

  subPackages = [ "cmd/reticulum-go" ];

  ldflags = [
    "-s"
    "-w"
  ];

  # Required for some tests on darwin.
  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/Quad4-Software/Reticulum-Go/releases/tag/${finalAttrs.src.tag}";
    description = "High-performance Go implementation of the Reticulum Network Stack";
    homepage = "https://github.com/Quad4-Software/Reticulum-Go";
    license = lib.licenses.asl20;
    mainProgram = "reticulum-go";
  };
})
