{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  perl,
  udev,
  openssl,
  gitMinimal,
  writableTmpDirAsHomeHook,
  installShellFiles,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "koji";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "cococonscious";
    repo = "koji";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qKC4ayaNPSUh4wSElBWxk/P+Y2dFgCIFiMkI0/QztDY=";
  };

  cargoHash = "sha256-vdELHNH1GqR0LPY3SSNgSR3krZZ85Tsx6aTHve0Vhe8=";

  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    pkg-config
    perl
    installShellFiles
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ udev ];

  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    git config --global user.name 'nix-user'
    git config --global user.email 'nix-user@example.com'
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd koji \
      --bash <($out/bin/koji completions bash) \
      --fish <($out/bin/koji completions fish) \
      --zsh <($out/bin/koji completions zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";

  meta = {
    description = "Interactive CLI for creating conventional commits";
    homepage = "https://github.com/its-danny/koji";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ByteSudoer
      WeetHet
    ];
    mainProgram = "koji";
    platforms = lib.platforms.unix;
  };
})
