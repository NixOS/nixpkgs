{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  nix-update-script,
  typos,
}:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.28.2";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6qu5Xe0lDT8u21VxU9lqs2BTre7BRa7+qNf8oukzTmc=";
  };

  cargoHash = "sha256-lC0K56eslfePdZfP75Lz6XRh3LORsAPShC15ZFj/UG4=";

  passthru = {
    tests.version = testers.testVersion { package = typos; };

    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Source code spell checker";
    mainProgram = "typos";
    homepage = "https://github.com/crate-ci/typos";
    changelog = "https://github.com/crate-ci/typos/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      figsoda
      mgttlinger
    ];
  };
}
