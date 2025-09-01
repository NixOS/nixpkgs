{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "somo";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "theopfr";
    repo = "somo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HUTaBSy3FemAQH1aKZYTJnUWiq0bU/H6c5Gz3yamPiA=";
  };

  cargoHash = "sha256-e3NrEfbWz6h9q4TJnn8jnRmMJbeaEc4Yo3hFlaRLzzQ=";

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Avoids "couldn't find any valid shared libraries matching: ['libclang.dylib']" error on darwin in sandbox mode.
    rustPlatform.bindgenHook
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd somo \
      --bash <("$out/bin/somo" generate-completions bash) \
      --zsh <("$out/bin/somo" generate-completions zsh) \
      --fish <("$out/bin/somo" generate-completions fish)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Socket and port monitoring tool";
    homepage = "https://github.com/theopfr/somo";
    changelog = "https://github.com/theopfr/somo/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "somo";
  };
})
