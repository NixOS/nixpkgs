{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "go-c8y-cli";
  version = "2.55.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "reubenmiller";
    repo = "go-c8y-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-swD2mFVn/N38HhdU8SCbmqcefyzWl4k/ARHkktYo2mQ=";
  };

  vendorHash = "sha256-1h4kdtdYUPqyCIhEDFRP2guduc2aXvvbolDIIFqrES0=";

  # subPackage cmd/gen-docs is only built here to generate man pages in
  # postInstall and is removed again in postInstall.
  subPackages = [
    "cmd/c8y"
  ]
  # only build gen-docs if postInstall is going to be run.
  ++ lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "cmd/gen-docs"
  ];

  ldflags = [
    "-s"
    "-X=github.com/reubenmiller/go-c8y-cli/v2/pkg/cmd.buildVersion=${finalAttrs.version}"
    "-X=github.com/reubenmiller/go-c8y-cli/v2/pkg/cmd.buildBranch=v2"
  ];

  nativeBuildInputs = [
    installShellFiles
    # c8y reads config from $HOME and might look for user-installed extensions
    writableTmpDirAsHomeHook
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    export C8Y_SETTINGS_CI=true
    export C8Y_SETTINGS_EXTENSIONS_DATADIR=$HOME/extensions

    $out/bin/gen-docs --man-page --doc-path ./man
    installManPage ./man/c8y*.1
    rm $out/bin/gen-docs

    installShellCompletion --cmd c8y \
      --bash <(SHELL=bash $out/bin/c8y completion bash) \
      --zsh <(SHELL=zsh $out/bin/c8y completion zsh) \
      --fish <(SHELL=fish $out/bin/c8y completion fish)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  doInstallCheck = true;
  versionCheckProgramArg = "version";
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cumulocity IoT command line tool";
    homepage = "https://goc8ycli.netlify.app/";
    changelog = "https://github.com/reubenmiller/go-c8y-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ skowalak ];
    mainProgram = "c8y";
  };
})
