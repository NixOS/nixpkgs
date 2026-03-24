{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "iwe";
  version = "0.0.64";

  src = fetchFromGitHub {
    owner = "iwe-org";
    repo = "iwe";
    tag = "iwe-v${finalAttrs.version}";
    hash = "sha256-aqoUTatYUUFKw3ZQYagQ0KchQM3JMgSzL/hG6CiyG9U=";
  };

  cargoHash = "sha256-iTudRDC53wZvWwuPYGG3rQfsC/th+3FwpiqZsZnbekg=";

  cargoBuildFlags = [
    "--package=iwe"
    "--package=iwes"
  ];

  preCheck = ''
    substituteInPlace crates/iwe/tests/common.rs --replace-fail \
      'binary_path.push("target");' \
      'binary_path.push("target/${stdenv.hostPlatform.rust.rustcTarget}");'

    # Tests here are looking for /usr to exist, which is not present in a build environment
    substituteInPlace crates/iwes/tests/transform_test.rs --replace-fail \
      'cwd: Some("/usr".to_string()),' \
      'cwd: Some("/tmp".to_string()),'
    substituteInPlace crates/iwes/tests/transform_test.rs --replace-fail \
      'vec![uri(1).to_edit("/usr\n")]' \
      'vec![uri(1).to_edit("/tmp\n")]'
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^iwe-v(.*)$"
    ];
  };

  meta = {
    description = "Personal knowledge management system (editor plugin & command line utility)";
    homepage = "https://iwe.md/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      phrmendes
      HeitorAugustoLN
    ];
    mainProgram = "iwe";
  };
})
