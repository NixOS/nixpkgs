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
  pname = "rwalk";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "cestef";
    repo = "rwalk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W42b3fUezMpOPaNmTogUbgn67nCiKteCkkYUAux9Ng4=";
  };

  cargoHash = "sha256-9zZLHjDpnxL3aR8zX4eNU1mpMDzMqzMC+Wr+DWVimUo=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Blazingly fast web directory scanner written in Rust";
    homepage = "https://github.com/cestef/rwalk";
    changelog = "https://github.com/cestef/rwalk/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pwnwriter ];
    mainProgram = "rwalk";
  };
})
