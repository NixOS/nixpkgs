{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdserve";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "jfernandez";
    repo = "mdserve";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C9D6tr88EROo2rzu7t9HAeyKAxFOCZyN+sl7QpFgmI8=";
  };

  cargoHash = "sha256-RFCGb7wjO8/RsOlsABem5dy+ZfheZNihktqUCX3oDZo=";

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # times out on darwin during nixpkgs-review
    "--skip test_file_modification_updates_via_websocket"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast markdown preview server with live reload and theme support";
    homepage = "https://github.com/jfernandez/mdserve";
    changelog = "https://github.com/jfernandez/mdserve/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      vinnymeller
      matthiasbeyer
    ];
    mainProgram = "mdserve";
  };
})
