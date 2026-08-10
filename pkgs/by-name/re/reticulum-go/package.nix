{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "reticulum-go";
  version = "1.0.1";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Quad4-Software";
    repo = "Reticulum-Go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QPf8MymZUW8DbYYgE1hGqKNQJNunyigJMgh/tYJaW1k=";
  };

  vendorHash = null;

  subPackages = [ "cmd/reticulum-go" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.defaultVersion=${finalAttrs.version}"
  ];

  # Required for some tests on darwin.
  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/Quad4-Software/Reticulum-Go/releases/tag/${finalAttrs.src.tag}";
    description = "High-performance Go implementation of the Reticulum Network Stack";
    homepage = "https://github.com/Quad4-Software/Reticulum-Go";
    license = lib.licenses.asl20;
    mainProgram = "reticulum-go";
    maintainers = with lib.maintainers; [ drupol ];
  };
})
