{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "opencode";
  version = "0.0.52";

  src = fetchFromGitHub {
    owner = "sst";
    repo = "opencode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wniGu8EXOI2/sCI7gv2luQgODRdes7tt1CoJ6Gs09ig=";
  };

  vendorHash = "sha256-pnev0o2/jirTqG67amCeI49XUdMCCulpGq/jYqGqzRY=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/sst/opencode/internal/version.Version=${finalAttrs.version}"
  ];

  checkFlags =
    let
      skippedTests = [
        # permission denied
        "TestBashTool_Run"
        "TestSourcegraphTool_Run"
        "TestLsTool_Run"

        # Difference with snapshot
        "TestGetContextFromPaths"
      ];
    in
    [ "-skip=^${lib.concatStringsSep "$|^" skippedTests}$" ];

  nativeCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Powerful terminal-based AI assistant providing intelligent coding assistance";
    homepage = "https://github.com/sst/opencode";
    changelog = "https://github.com/sst/opencode/releases/tag/v${finalAttrs.version}";
    mainProgram = "opencode";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      zestsystem
    ];
  };
})
