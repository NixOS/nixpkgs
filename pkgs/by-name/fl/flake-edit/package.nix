{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flake-edit";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "a-kenji";
    repo = "flake-edit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YQw44sh//aOufTNyFRit8PxcpR++/98LhxBgQadqJzY=";
  };

  cargoHash = "sha256-5jYR4herhAa2q2cCrqcUOBG3mxb4XZzmOXIhc4nxShU=";

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
    changelog = "https://github.com/a-kenji/flake-edit/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ a-kenji ];
    mainProgram = "flake-edit";
  };
})
