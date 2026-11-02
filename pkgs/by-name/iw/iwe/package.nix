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
  version = "0.29.3";

  src = fetchFromGitHub {
    owner = "iwe-org";
    repo = "iwe";
    tag = "iwe-v${finalAttrs.version}";
    hash = "sha256-M0V3oGe2btsA+CKCQFiVPOK/nt589TfHjqgm06Kr9m0=";
  };

  cargoHash = "sha256-XVemeR0tyDlzXYtjJzruH73XJnwRlR1AKeq8VD4yaOg=";

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
