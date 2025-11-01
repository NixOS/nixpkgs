{
  lib,
  rustPlatform,
  fetchFromGitLab,
  testers,
  commitmsgfmt,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "commitmsgfmt";
  version = "1.7.0";

  src = fetchFromGitLab {
    owner = "mkjeldsen";
    repo = "commitmsgfmt";
    rev = "v${version}";
    hash = "sha256-6mMjDMWkpaKXqmyE2taV4pDa92Tdt4VEHHLdOpRHung=";
  };

  cargoHash = "sha256-Ewn7NCFtl8phC5cFyLWZcGZy4w+huummzeuXFRn64lQ=";

  passthru.tests.version = testers.testVersion {
    package = commitmsgfmt;
    command = "commitmsgfmt -V";
  };
  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://gitlab.com/mkjeldsen/commitmsgfmt";
    changelog = "https://gitlab.com/mkjeldsen/commitmsgfmt/-/raw/v${version}/CHANGELOG.md";
    description = "Formats commit messages better than fmt(1) and Vim";
    mainProgram = "commitmsgfmt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mmlb ];
  };
}
