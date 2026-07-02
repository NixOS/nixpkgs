{
  lib,
  cacert,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stalwart-cli";
  version = "1.0.9";
  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SZefTApX3FT6M7Zr3CAIfZfgkECJb54xTGdoPPII8Q4=";
  };
  cargoHash = "sha256-D6TN5IIlX9PL2+qP0e8QBoalgfgN+xT2poD7wMh5TB8=";
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
