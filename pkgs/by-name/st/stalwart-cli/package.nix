{
  lib,
  rustPlatform,
  versionCheckHook,
  stalwart-mail,
}:

rustPlatform.buildRustPackage rec {
  pname = "stalwart-cli";
  version = stalwart-mail.version;
  src = stalwart-mail.src;

  buildAndTestSubdir = "crates/cli";
  useFetchCargoVendor = true;
  cargoHash = "sha256-k0pNNLwFRLI7eHjVwHGjgrnX4moWOwoWvMiyPfGMgCo=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];

  meta = {
    description = "Stalwart Mail Server CLI";
    homepage = "https://github.com/stalwartlabs/mail-server";
    changelog = "https://github.com/stalwartlabs/mail-server/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    mainProgram = "stalwart-cli";
    maintainers = with lib.maintainers; [
      giomf
    ];
  };
}
