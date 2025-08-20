{
  lib,
  rustPlatform,
  fetchFromGitLab,
  testers,
  commitmsgfmt,
}:
rustPlatform.buildRustPackage rec {
  pname = "commitmsgfmt";
  version = "1.6.0";

  src = fetchFromGitLab {
    owner = "mkjeldsen";
    repo = "commitmsgfmt";
    rev = "v${version}";
    hash = "sha256-HEkPnTO1HeJg8gpHFSUTkEVBPWJ0OdfUhNn9iGfaDD4=";
  };
  cargoHash = "sha256-jTRB9ogFQGVC4C9xpGxsJYV3cnWydAJLMcjhzUPULTE=";

  passthru.tests.version = testers.testVersion {
    package = commitmsgfmt;
    command = "commitmsgfmt -V";
  };

  meta = with lib; {
    homepage = "https://gitlab.com/mkjeldsen/commitmsgfmt";
    changelog = "https://gitlab.com/mkjeldsen/commitmsgfmt/-/raw/v${version}/CHANGELOG.md";
    description = "Formats commit messages better than fmt(1) and Vim";
    mainProgram = "commitmsgfmt";
    license = licenses.asl20;
    maintainers = with maintainers; [ mmlb ];
  };
}
