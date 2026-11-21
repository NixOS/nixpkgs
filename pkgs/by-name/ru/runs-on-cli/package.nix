{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "runs-on-cli";
  version = "3.6.2";

  src = fetchFromGitHub {
    owner = "runs-on";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mxAm2zAO7voX9gPuIcFrnk4PC5tNFeOUzW+dp8Z8c74=";
  };

  __structuredAttrs = true;

  postPatch = ''
    # Upstream bumps Go at a faster cadence than nixpkgs
    sed -i -E 's/^(go [0-9]+\.[0-9]+)\.[0-9]+$/\1/' go.mod
  '';

  vendorHash = "sha256-8S/peKk4MjBAWz+S24Y/2hXTjQXt2c0hxfG2FOK0iXQ=";

  # Test spins up an httptest server, which needs a loopback bind
  __darwinAllowLocalNetworking = true;

  ldflags = [
    "-X roc/internal/version.Version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for RunsOn";
    homepage = "https://github.com/runs-on/cli";
    changelog = "https://github.com/runs-on/cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shunueda ];
    mainProgram = "roc";
  };
})
