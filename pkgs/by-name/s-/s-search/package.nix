{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  testers,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "s-search";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "zquestz";
    repo = "s";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dqmn0DgeurJpEArhvmEq5Yl5+LMNJOUDd+Jl9KwAiUU=";
  };

  vendorHash = "sha256-ITK4xFT4m0AGcj2bB7mvIQ3+6qyFVZACXPjhVx5aLx4=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd s \
      --bash <($out/bin/s --completion bash) \
      --fish <($out/bin/s --completion fish) \
      --zsh <($out/bin/s --completion zsh)
  '';

  passthru = {
    # `versionCheckHook` fails due to the program requires `sh` to be available in `PATH`
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "s --version";
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Web search from the terminal";
    longDescription = ''
      Command-line tool that generates a search query link and opens it in the
      browser of your choice.
    '';
    homepage = "https://github.com/zquestz/s";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      yzx9
    ];
    mainProgram = "s";
  };
})
