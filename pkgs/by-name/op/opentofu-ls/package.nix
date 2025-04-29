{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  unstableGitUpdater,
}:

buildGoModule {
  pname = "opentofu-ls";
  version = "0-unstable-2025-02-26";

  src = fetchFromGitHub {
    owner = "opentofu";
    repo = "opentofu-ls";
    rev = "978a5fb56519a9f17833709119d2eb5fe604784e";
    hash = "sha256-xBJkIuYqqUan2fo+s426vEIr5Qri8dM5arJACvKFjws=";
  };

  vendorHash = "sha256-CrbLqcwPXHB80m4VhqrC8j5VhU2BUeuNy87+bc+Bq6I=";

  ldflags = [
    "-s"
    "-w"
  ];

  checkFlags =
    let
      skippedTests = [
        # Require network access
        "TestCompletion_moduleWithValidData"
        "TestCompletion_multipleModulesWithValidData"
        "TestCompletion_multipleModulesWithValidData"
        "TestExec_cancel"
        "TestLangServer_DidChangeWatchedFiles_moduleInstalled"
        "TestLangServer_workspace_symbol_basic"
        "TestLangServer_workspace_symbol_missing"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  __darwinAllowLocalNetworking = true;

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "OpenTofu Language Server";
    homepage = "https://github.com/opentofu/opentofu-ls";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "opentofu-ls";
  };
}
