{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  gitMinimal,
  stdenv,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rumdl";
  version = "0.1.91";

  src = fetchFromGitHub {
    owner = "rvben";
    repo = "rumdl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hn9YHFG8wbU8cY96MUT1fsRTzMqkCdJKnQsBgRNRVjo=";
  };

  cargoHash = "sha256-OUzZ2CLda5VqNLFX6hzd4+MPXcUPsTWerWravZDJJfU=";

  cargoBuildFlags = [
    "--bin=rumdl"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  nativeCheckInputs = [
    gitMinimal
  ];

  __darwinAllowLocalNetworking = true;

  useNextest = true;

  cargoTestFlags = [
    "--lib"

    # Prefer the "smoke" profile over "ci" to exclude flaky tests: https://github.com/rvben/rumdl/pull/341
    "--profile"
    "smoke"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd rumdl \
      --bash <("$out/bin/rumdl" completions bash) \
      --fish <("$out/bin/rumdl" completions fish) \
      --zsh <("$out/bin/rumdl" completions zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Markdown linter and formatter";
    longDescription = ''
      rumdl is a high-performance Markdown linter and formatter
      that helps ensure consistency and best practices in your Markdown files.
    '';
    homepage = "https://github.com/rvben/rumdl";
    changelog = "https://github.com/rvben/rumdl/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kachick
      hasnep
    ];
    mainProgram = "rumdl";
    platforms = with lib.platforms; unix ++ windows;
  };
})
