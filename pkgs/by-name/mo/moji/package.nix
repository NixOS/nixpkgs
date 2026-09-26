{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "moji";
  version = "0.8.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Microck";
    repo = "moji";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Of9Os3h7cvJIf3dfj4aD1TX9/4SGsuY4Hjm2Kh4c1rY=";
  };

  vendorHash = "sha256-cCCwL7bqn+23YeLMiDEyCv+Gcu0xw068DgJDgaMb2tY=";

  subPackages = [ "cmd/moji" ];
  excludedPackages = [ "e2e" ];

  preCheck = ''
    unset subPackages
  '';

  checkFlags =
    let
      skippedTests = [
        "TestConfigCompactLayoutPutsValuesBelowLabels"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  ldflags = [
    "-s"
    "-X github.com/microck/moji/internal/app.Version=${finalAttrs.version}"
    "-X github.com/microck/moji/internal/app.ReleaseMarker=moji-release-version:${finalAttrs.version}:moji-marker-end"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Find and download fonts from the terminal";
    homepage = "https://github.com/Microck/moji";
    changelog = "https://github.com/Microck/moji/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yarn ];
    mainProgram = "moji";
  };
})
