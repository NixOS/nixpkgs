{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "reticulum-go";
  version = "0.9.6";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Quad4-Software";
    repo = "Reticulum-Go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Rji6MJQAN48zKsLHQS8ukbi9pWjHPEbezXJu/700HZs=";
  };

  # TODO: Remove this when https://github.com/NixOS/nixpkgs/pull/527289 has landed in `master`
  postPatch = ''
    substituteInPlace go.mod \
      --replace-fail "1.26.4" "1.26.3"
  '';

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
    maintainers = with lib.maintainers; [ drupol ];
  };
})
