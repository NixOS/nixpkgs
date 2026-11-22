{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  gitMinimal,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "iwe";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "iwe-org";
    repo = "iwe";
    tag = "iwe-v${finalAttrs.version}";
    hash = "sha256-hmHNNmUBL5SjXNQenFnJY8Ua46uQsRuhjvbgTg7SH2Q=";
  };

  cargoHash = "sha256-u6g+oCHlp5nTPb+2srV5a5HZseyF0zl5VvqMo/od9Tg=";

  cargoBuildFlags = [
    "--package=iwe"
    "--package=iwec"
    "--package=iwes"
  ];

  nativeCheckInputs = [ gitMinimal ];
  __darwinAllowLocalNetworking = true;

  preCheck = ''
    substituteInPlace crates/iwe/tests/common.rs --replace-fail \
      'binary_path.push("target");' \
      'binary_path.push("target/${stdenv.hostPlatform.rust.rustcTarget}");'
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
