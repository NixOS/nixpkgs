{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  git,
  versionCheckHook,
  nix-update-script,
}:

buildGo127Module (finalAttrs: {
  pname = "rexdiff";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "frinfo702";
    repo = "rexdiff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QaWkL0TOVNIjjPAbA02n11CzmPdFRZhpP6oTFZQDrNQ=";
  };

  __structuredAttrs = true;

  vendorHash = "sha256-7bU/Nr4WwIW8RZWqEC5RnUdCGqAF3/nVB5KeumkAacM=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  nativeCheckInputs = [ git ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Diff viewer for coding agents in Rex";
    homepage = "https://github.com/frinfo702/rexdiff";
    changelog = "https://github.com/frinfo702/rexdiff/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ frinfo702 ];
    mainProgram = "rexdiff";
    platforms = lib.platforms.unix;
  };
})
