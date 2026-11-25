{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  git,
  nodejs,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "px0";
  version = "0.1.21";

  src = fetchFromGitHub {
    owner = "px0-ai";
    repo = "px0";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rOWJV6kEMHjnC0mEOGUeoB0HPOWk1Tv9OMRnRNk2Qvk=";
  };

  __structuredAttrs = true;

  __darwinAllowLocalNetworking = true;

  vendorHash = "sha256-GJAd0mo4s7ybFizzXvfT79CyDR/qC6BkbUtS/2y1XEI=";

  nativeBuildInputs = [ nodejs ];

  nativeCheckInputs = [ git ];

  preBuild = ''
    node scripts/build-web.js
  '';

  checkFlags =
    let
      skippedTests = [
        # The source tag does not contain the bundled Mermaid script.
        "TestStaticAssetServing"
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        "TestListenPortFallback"
        "TestTelemetrySessionLifecycle"
      ];
    in
    [
      "-skip"
      "^(${lib.concatStringsSep "|" skippedTests})$"
    ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, ultra-light, remote-first IDE for code navigation and review in your browser";
    homepage = "https://github.com/px0-ai/px0";
    changelog = "https://github.com/px0-ai/px0/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sheeeng ];
    mainProgram = "px0";
  };
})
