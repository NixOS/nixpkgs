{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
  testers,
  commitlint-rs,
}:
rustPlatform.buildRustPackage rec {
  pname = "commitlint-rs";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "KeisukeYamashita";
    repo = "commitlint-rs";
    rev = "v${version}";
    hash = "sha256-xDEd3jNmqur+ULjXOReolIDiqvpT2tAHj/IbH2op5Po=";
  };
  cargoHash = "sha256-SNOy0B1QARfoueMsCjLZhJsGQy2jTSeFC/D1+R/FH4Y=";

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = commitlint-rs; };
  };

  meta = with lib; {
    description = "Lint commit messages with conventional commit messages";
    homepage = "https://keisukeyamashita.github.io/commitlint-rs";
    changelog = "https://github.com/KeisukeYamashita/commitlint-rs/releases/tag/${src.rev}";
    license = with licenses; [
      mit
      asl20
    ];
    mainProgram = "commitlint";
    platforms = with platforms; unix ++ windows;
    maintainers = with maintainers; [
      croissong
      getchoo
    ];
  };
}
