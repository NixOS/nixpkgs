{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  libredirect,
  iana-etc,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "somo";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "theopfr";
    repo = "somo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LURaGG0S3qE7lK4CgDEoNfJJOzZT3/FAQB6Bgt3/a3Y=";
  };

  cargoHash = "sha256-KZxEHwmLTFs0RqjvM8DbropsbiYEMNmsOOgFUNKE8Ls=";

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Avoids "couldn't find any valid shared libraries matching: ['libclang.dylib']" error on darwin in sandbox mode.
    rustPlatform.bindgenHook
  ];

  nativeCheckInputs = [
    libredirect.hook
  ];

  preCheck = ''
    export NIX_REDIRECTS=/etc/services=${iana-etc}/etc/services
  '';

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
