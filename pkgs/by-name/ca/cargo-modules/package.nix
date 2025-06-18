{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-modules";
  version = "0.24.2";

  src = fetchFromGitHub {
    owner = "regexident";
    repo = "cargo-modules";
    tag = "v${version}";
    hash = "sha256-Z6CbH0a2LCHtFQeiHXAC8ebysVLueHNlqxDe+Q3Tbyc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-8MNhuvYfIVAIsnHFyz38CY0YOgqc9AwEh3W5kn9Gs3k=";

  checkFlags = [
    "--skip=cfg_test::with_tests::smoke"
    "--skip=cfg_test::without_tests::smoke"
    "--skip=colors::ansi::smoke"
    "--skip=colors::plain::smoke"
    "--skip=colors::truecolor::smoke"
    "--skip=fields::enum_fields"
    "--skip=fields::struct_fields"
    "--skip=fields::tuple_fields"
    "--skip=fields::union_fields"
    "--skip=focus_on::glob_path::smoke"
    "--skip=focus_on::self_path::smoke"
    "--skip=focus_on::simple_path::smoke"
    "--skip=focus_on::use_tree::smoke"
    "--skip=functions::function_body"
    "--skip=functions::function_inputs"
    "--skip=functions::function_outputs"
    "--skip=max_depth::depth_2::smoke"
    "--skip=selection::no_fns::smoke"
    "--skip=selection::no_modules::smoke"
    "--skip=selection::no_traits::smoke"
    "--skip=selection::no_types::smoke"
    "--skip=selection::no_owns::smoke"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  meta = {
    description = "Cargo plugin for showing a tree-like overview of a crate's modules";
    homepage = "https://github.com/regexident/cargo-modules";
    changelog = "https://github.com/regexident/cargo-modules/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      figsoda
      rvarago
      matthiasbeyer
    ];
    mainProgram = "cargo-modules";
  };
}
