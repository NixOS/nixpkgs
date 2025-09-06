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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "theopfr";
    repo = "somo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QTW+hsoj8Wrv3BbFCB2aibR27Wu1MA/1gWzAXtPKWsM=";
  };

  cargoHash = "sha256-xlAdEo11UV1Y49D1LjxH5Oykf/RUoe1w6ZcQpGhfqkk=";

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Avoids "couldn't find any valid shared libraries matching: ['libclang.dylib']" error on darwin in sandbox mode.
    rustPlatform.bindgenHook
  ];

  # It depends on system files likely /etc/services and don't use iana-etc to respect user customized files
  # See https://github.com/NixOS/nixpkgs/pull/439590#discussion_r2325080667 for detail
  doCheck = false;

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
