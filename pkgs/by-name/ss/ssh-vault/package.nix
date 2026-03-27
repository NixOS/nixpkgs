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
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "ssh-vault";
    repo = "ssh-vault";
    tag = finalAttrs.version;
    hash = "sha256-hxPeVJletH0/yy70qA8kZOWgaQ+B8sgG4OuIdt1IgWo=";
  };

  cargoHash = "sha256-72pwe384u/il3Dh19il72el0DZ/+9q/tNHAAOdzedoc=";

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
