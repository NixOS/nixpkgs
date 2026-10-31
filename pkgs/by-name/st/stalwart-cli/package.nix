{
  lib,
  cacert,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stalwart-cli";
  version = "1.0.14";
  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3SotRkEDIrI3hgYFjAkkKhCZoD/woXreLshBaLr0Y2c=";
  };
  cargoHash = "sha256-/vYb083UVPDZQpDWh16XkMWk+n9081OiV9S1i1om5zQ=";
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
      lib.licenses.stalwart
    ];
    mainProgram = "stalwart-cli";
    maintainers = with lib.maintainers; [
      debtquity
    ];
  };
})
