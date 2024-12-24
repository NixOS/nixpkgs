{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  testers,
  mprocs,
}:

rustPlatform.buildRustPackage rec {
  pname = "mprocs";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "pvolok";
    repo = "mprocs";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-gK2kgc0Y0s1xys+pUadi8BhGeYxtyKRhNycCoqftmDI=";
  };

  cargoHash = "sha256-lcs+x2devOEZg5YwAzlZKJl6VpCJXzVqNUr6N5pCei8=";

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = mprocs; };
  };

  meta = {
    description = "TUI tool to run multiple commands in parallel and show the output of each command separately";
    homepage = "https://github.com/pvolok/mprocs";
    changelog = "https://github.com/pvolok/mprocs/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      GaetanLepage
      pyrox0
    ];
    platforms = lib.platforms.unix;
    mainProgram = "mprocs";
  };
}
