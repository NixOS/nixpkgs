{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "stalwart-cli";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "cli";
    tag = "v1.0.0";
    hash = "sha256-xTxOYbPZ7zkweuuTJx3Alqig74KiD67i+TRzh1BZXa4=";
  };

  cargoHash = "sha256-Z5MDM5nJvjQJ9PpS07LbUc9FjVuwhRguchakjwypSDo=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  env.OPENSSL_NO_VENDOR = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Stalwart Mail Server CLI";
    homepage = "https://github.com/stalwartlabs/cli";
    changelog = "https://github.com/stalwartlabs/cli/blob/main/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    mainProgram = "stalwart-cli";
    maintainers = with lib.maintainers; [
      giomf
    ];
  };
}
