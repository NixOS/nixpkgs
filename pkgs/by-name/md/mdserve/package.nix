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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "jfernandez";
    repo = "mdserve";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t8eQBzdR5+O5U85HSRj6P7PgE7ubZhY8IkNXsDEpy+w=";
  };

  cargoHash = "sha256-jBTbScyflkvhwfOu4DHkcsfxogjgSGXBAF2euq3lZEo=";

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  checkFlags = [
    "--skip=app::tests::test_temp_file_rename_triggers_reload_directory_mode"
    "--skip=app::tests::test_temp_file_rename_triggers_reload_single_file_mode"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # times out on darwin during nixpkgs-review
    "--skip=test_file_modification_updates_via_websocket"
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
