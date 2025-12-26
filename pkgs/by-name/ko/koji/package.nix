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
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "cococonscious";
    repo = "koji";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8z7lx0aVmA2gbydeJOBDVM2s6rwZpDLRaw1yqErwhJ4=";
  };

  cargoHash = "sha256-dnidKrH/HSUpm8sU51G4e74NgyyO3v2sTK4eDKSJujA=";

  OPENSSL_NO_VENDOR = 1;

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
