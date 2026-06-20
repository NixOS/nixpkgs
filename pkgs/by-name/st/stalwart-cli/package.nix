{
  lib,
  cacert,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stalwart-cli";
  version = "1.0.8";
  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-teQB+6ZPEH3RXxG8WX4L67ckLCTYfMF4xaiz3S074b0=";
  };
  cargoHash = "sha256-yMfWFTXV1gXPqo2OOAN/Fkym9UiHjXDX0tAJOCF2p4U=";
  __structuredAttrs = true;
  # `Result::unwrap()` on an `Err` value: Network(reqwest::Error { kind: Builder, source: General("No CA certificates were loaded from the system") })
  nativeCheckInputs = [ cacert ];
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  meta = {
    description = "Stalwart Command Line Interface";
    longDescription = ''
      A schema-driven command line tool for administering Stalwart Mail and Collaboration Server over its JMAP API.

      The tool fetches the server's schema on first use and derives every command, validation rule, and rendered view from it. The same binary works against any compatible Stalwart deployment without recompilation.
    '';
    homepage = "https://github.com/stalwartlabs/cli";
    changelog = "https://github.com/stalwartlabs/cli/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.OR [
      lib.licenses.agpl3Only
      {
        fullName = "Stalwart Enterprise License 2.0 (SELv2) Agreement";
        url = "https://github.com/stalwartlabs/cli/blob/main/LICENSES/LicenseRef-SEL.txt";
        free = false;
        redistributable = false;
      }
    ];
    mainProgram = "stalwart-cli";
    maintainers = with lib.maintainers; [
      giomf
      debtquity
    ];
  };
})
