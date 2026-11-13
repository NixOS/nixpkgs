{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGo127Module (finalAttrs: {
  pname = "runs-on-cli";
  version = "3.6.1";

  src = fetchFromGitHub {
    owner = "runs-on";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/gl8pvBmGoeQKMYAPQZGjxJHaIKeq3MQ1XZQ6OQbHWo=";
  };

  __structuredAttrs = true;

  postPatch = ''
    # Upstream bumps Go at a faster cadence than nixpkgs
    substituteInPlace go.mod --replace-fail "go 1.27.4" "go 1.27.3"
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
