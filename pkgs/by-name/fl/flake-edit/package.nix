{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  installShellFiles,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "flake-edit";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "a-kenji";
    repo = "flake-edit";
    rev = "v${version}";
    hash = "sha256-dNTvAYBVZLeDlC1bsaonwojE7+1CD16/sCxtQVvT9WE=";
  };

  cargoHash = "sha256-ipLjbfnNqrUUD40awRnE8URX5pHhG4SwUM9JedoBM8Y=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  env.ASSET_DIR = "target/assets";

  postInstall = ''
    installManPage target/assets/flake-edit.1

    installShellCompletion --bash --name flake-edit.bash target/assets/flake-edit.bash
    installShellCompletion --fish --name flake-edit.fish target/assets/flake-edit.fish
    installShellCompletion --zsh --name _flake-edit target/assets/_flake-edit
  '';

  meta = {
    description = "Edit your flake inputs with ease";
    homepage = "https://github.com/a-kenji/flake-edit";
    changelog = "https://github.com/a-kenji/flake-edit/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ a-kenji ];
    mainProgram = "flake-edit";
  };
}
