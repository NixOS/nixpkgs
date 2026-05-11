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
  version = "1.2.8";

  src = fetchFromGitHub {
    owner = "ssh-vault";
    repo = "ssh-vault";
    tag = finalAttrs.version;
    hash = "sha256-kJscLetdP4D6DzzERfohezdsJqGcm/dmYTC+ZxjvRvo=";
  };

  cargoHash = "sha256-XFKqEwWDg8FUeObhI6oOIXNh8c7gsWgSWy3YThExuU4=";

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
