{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ssh-vault";
  version = "1.2.10";

  src = fetchFromGitHub {
    owner = "ssh-vault";
    repo = "ssh-vault";
    tag = finalAttrs.version;
    hash = "sha256-bvTZTsNnEKN1Ghf4ySpGxTmchJh82jZ4bkz4Z3cG+Ug=";
  };

  cargoHash = "sha256-s7AOT5T6rLmTrWV8hMGGHLk4HGiOoHYDt/4DejGhWLg=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  # `test_setup_io` requires to be executed in an interactive shell
  checkFlags = [
    "--skip"
    "vault::dio::tests::test_setup_io"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    mkdir --parents $HOME/.ssh/vault
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Encrypt/decrypt using SSH keys";
    homepage = "https://github.com/ssh-vault/ssh-vault";
    changelog = "https://github.com/ssh-vault/ssh-vault/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "ssh-vault";
  };
})
