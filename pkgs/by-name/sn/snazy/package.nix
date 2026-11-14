{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "snazy";
  version = "0.59.1";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "snazy";
    rev = finalAttrs.version;
    hash = "sha256-qbfj54TnMIkoU2PSmzF+4GcDzy5nGWSNlRwIBgTixQw=";
  };

  cargoHash = "sha256-R26DUgqjS0sGlkZIN6MkL0ERXaqG89GLBfAfUsN7Bag=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd snazy \
      --bash <($out/bin/snazy --shell-completion bash) \
      --fish <($out/bin/snazy --shell-completion fish) \
      --zsh <($out/bin/snazy --shell-completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/snazy --help
    $out/bin/snazy --version | grep "snazy ${finalAttrs.version}"
    runHook postInstallCheck
  '';

  meta = {
    description = "Snazzy json log viewer";
    mainProgram = "snazy";
    longDescription = ''
      Snazy is a simple tool to parse json logs and output them in a nice format
      with nice colors.
    '';
    homepage = "https://github.com/chmouel/snazy/";
    changelog = "https://github.com/chmouel/snazy/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jk
    ];
  };
})
