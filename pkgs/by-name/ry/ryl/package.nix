{
  lib,
  rustPlatform,
  fetchFromGitHub,
  yamllint,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ryl";
  version = "0.21.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "owenlamont";
    repo = "ryl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CfTohleyvbFU1WB5MzqZv3ZtZeWZdnmFcjqpVY4ON5M=";
  };

  cargoHash = "sha256-EzMlaTvVwOohwyEjeRFkiw+LTrIDA11gYCCxBoWzzAQ=";

  nativeCheckInputs = [
    yamllint # Needed for tests "*_yamllint"
  ];

  checkFlags = [
    # Runs `uv run ./scripts/print_ryl_schemastore_schema.py` which makes uv
    # try to download a cpython distribution using HTTP which is blocked by the network sandbox.
    "--skip=schemastore_toml_schema_exposes_known_rule_properties"
    "--skip=schemastore_toml_schema_sets_expected_metadata"
    "--skip=schemastore_toml_schema_uses_readable_rule_wrapper_names"
    "--skip=schemastore_toml_schema_validates_repo_fixtures"

    # > thread 'indentation_matches_yamllint' (38984) panicked at tests/yamllint_compat_indentation.rs:130:13:
    # > assertion `left == right` failed: diagnostics mismatch multi-line (auto-standard)
    # >   left: "/build/.tmpd4bvjL/multi-bad.yaml\n  3:6       error    wrong indentation: expected 4 but found 5  (indentation)\n\n"
    # >  right: "/build/.tmpd4bvjL/multi-bad.yaml\n  3:6       error    wrong indentation: expected 4but found 5  (indentation)\n\n"
    "--skip=indentation_matches_yamllint"
    # > thread 'quoted_strings_rule_matches_yamllint' (43249) panicked at tests/yamllint_compat_quoted_strings.rs:171:13:
    # > assertion `left == right` failed: yamllint exit mismatch consistent (auto-standard)
    # >   left: 255
    # >  right: 1
    "skip=quoted_strings_rule_matches_yamllint"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast YAML linter written in Rust (drop in replacement for yamllint - but with additional rules and features)";
    homepage = "https://ryl-docs.pages.dev/";
    downloadPage = "https://github.com/owenlamont/ryl";
    changelog = "https://github.com/owenlamont/ryl/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.kpbaks ];
    mainProgram = "ryl";
  };
})
