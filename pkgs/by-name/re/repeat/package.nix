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
  pname = "repeat";
  version = "0.0.23";

  src = fetchFromGitHub {
    owner = "shaankhosla";
    repo = "repeat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jioRtvsrSdqa22H7IX6EA9XDF05+7xg0li7GmmxrgqA=";
  };

  cargoHash = "sha256-xlnwZHC4ALOvpdur2C07/76BxLXUplD97lX00Mt3hpU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Spaced repetition, in your terminal";
    homepage = "https://github.com/shaankhosla/repeat";
    changelog = "https://github.com/shaankhosla/repeat/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "repeat";
  };
})
