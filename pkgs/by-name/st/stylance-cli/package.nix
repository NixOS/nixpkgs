{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stylance-cli";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "basro";
    repo = "stylance-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WqjT2mkVRQJ21fbv6GuFAuHfW6F24RPCcD1/IXxsE5A=";
  };

  cargoHash = "sha256-m1NFshjjaFR3Fre7bY2ZzFp9+uHq6T/tDSQmt/Cc6E8=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  meta = {
    description = "Library and cli tool for working with scoped CSS in rust";
    mainProgram = "stylance";
    homepage = "https://github.com/basro/stylance-rs";
    changelog = "https://github.com/basro/stylance-rs/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ dav-wolff ];
  };
})
