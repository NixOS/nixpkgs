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
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "ssh-vault";
    repo = "ssh-vault";
    tag = finalAttrs.version;
    hash = "sha256-po0Zb52TVfqHxqlHPmBCqr5zgj49Ks5n0rZDiOvixcM=";
  };

  cargoHash = "sha256-pd52vYtN4JmOyDstNBX7ssJk/IpiGnekc7L+knf+RzQ=";

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
  versionCheckProgramArg = "--version";

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
