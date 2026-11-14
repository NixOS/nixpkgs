{
  lib,
  buildGoModule,
  fetchFromGitHub,
  osv-detector,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "osv-detector";
  version = "0.16.2";

  src = fetchFromGitHub {
    owner = "G-Rath";
    repo = "osv-detector";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3XKH2CgZeawzmIMQPMGLz9A1ax1L3ynrwpQmvOiHBgo=";
  };

  vendorHash = "sha256-zjoscB0dy9rStDWpGS9XLxvCcIJaa1zNjETxx9hpPYw=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-X=main.version=${finalAttrs.version}"
  ];

  preCheck = ''
    # go-snaps fails the run when skipped tests leave orphaned snapshot files
    export CI=false
    export UPDATE_SNAPS=clean
  '';

  checkFlags =
    let
      skippedTests = [
        # Disable tests requiring network access
        "TestRun_ParseAs_CsvFile"
        "TestRun_ParseAs_CsvRow"
        "TestRun_DBs"
        "TestRun_Lockfile"
        "TestRun_ParseAsGlobal"
        "TestRun_Ignores"
        "TestRun_ParseAsSpecific"
        "TestRun_Configs"
        # Snapshots are outdated
        "TestRun_APIError"
        "TestRun_UpdatingConfigIgnores"
      ];
    in
    [
      "-skip"
      "${builtins.concatStringsSep "|" skippedTests}"
    ];

  doInstallCheck = true;

  meta = {
    description = "Auditing tool for detecting vulnerabilities";
    homepage = "https://github.com/G-Rath/osv-detector";
    changelog = "https://github.com/G-Rath/osv-detector/releases/tag/v${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "osv-detector";
  };
})
