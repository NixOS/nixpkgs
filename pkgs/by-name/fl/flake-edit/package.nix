{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "flake-edit";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "a-kenji";
    repo = "flake-edit";
    rev = "v${version}";
    hash = "sha256-7n8WANm9AijZYI5nlnevLI+aZtV55teroeQIEld7tkE=";
  };

  cargoHash = "sha256-hK79yHSneD9OFm+M+RPSfu6HW1MmdpcMLysPIKlFDv8=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [ openssl ];

  env.ASSET_DIR = "target/assets";

  postInstall = ''
    installManPage target/assets/flake-edit.1

    installShellCompletion --bash --name flake-edit.bash target/assets/flake-edit.bash
    installShellCompletion --fish --name flake-edit.fish target/assets/flake-edit.fish
    installShellCompletion --zsh --name _flake-edit target/assets/_flake-edit
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Edit your flake inputs with ease";
    homepage = "https://github.com/a-kenji/flake-edit";
    changelog = "https://github.com/a-kenji/flake-edit/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ a-kenji ];
    mainProgram = "flake-edit";
  };
}
