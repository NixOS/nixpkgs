{
  lib,
  fetchFromGitHub,
  buildGoModule,
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

  checkFlags =
    let
      skippedTests = [
        # Requires external hashicorp dependencies
        "TestLangServer_DidChangeWatchedFiles_moduleInstalled"
        "TestCompletion_moduleWithValidData"
        "TestCompletion_multipleModulesWithValidData"
        "TestExec_cancel"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  meta = {
    description = "OpenTofu Language Server";
    homepage = "https://github.com/opentofu/opentofu-ls";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "opentofu-ls";
  };
}
