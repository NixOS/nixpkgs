{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  unstableGitUpdater,
}:

buildGoModule {
  pname = "opentofu-ls";
  version = "0-unstable-2025-01-01";

  src = fetchFromGitHub {
    owner = "opentofu";
    repo = "opentofu-ls";
    rev = "e6fe83c83107728dd39bb9324b8e1ecc31ad44d3";
    hash = "sha256-3d/vlW+U1YrGR34edyaMZmV6HaMra0yDCgnQwkQGzuY=";
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
