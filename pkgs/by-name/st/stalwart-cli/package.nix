{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "stalwart-cli";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "mail-server";
    tag = "v${version}";
    hash = "sha256-Ku6WfsEpBCR4HbS3HTQLmoJipJT1heZ3AQvPSbnc7tI=";
  };

  buildAndTestSubdir = "crates/cli";
  cargoHash = "sha256-cSb+whRS0mBZsJe+rwHv98MEKtYo1QRLhs3eNbjYOis=";

  # Currently disabled because of a mismatch in versioning:
  # https://github.com/stalwartlabs/mail-server/blob/84a39bd6a42e0d45e793d6fb7d2158bbe740486e/crates/cli/Cargo.toml#L8
  # Should be enabled again in next version!
  # doInstallCheck = true;
  # nativeInstallCheckInputs = [ versionCheckHook ];
  # versionCheckProgramArg = [ "--version" ];

  meta = {
    description = "Stalwart Mail Server CLI";
    homepage = "https://github.com/stalwartlabs/mail-server";
    changelog = "https://github.com/stalwartlabs/mail-server/blob/main/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    mainProgram = "stalwart-cli";
    maintainers = with lib.maintainers; [
      giomf
    ];
  };
}
