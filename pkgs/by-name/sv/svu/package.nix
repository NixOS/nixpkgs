{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  svu,
  installShellFiles,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "svu";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "svu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KSNf4FQ7Shh0ggdoy9oFuM6AIoDKMaAO2NlvCFWHW8c=";
  };

  vendorHash = "sha256-SWS8P2eJ1lPjPQ4GmvPcHg4II3Dv72b7UbyFg2uRj6g=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.builtBy=nixpkgs"
  ];

  # test assumes source directory to be a git repository
  postPatch = ''
    rm internal/git/git_test.go
  '';

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd svu \
      --bash <($out/bin/svu completion bash) \
      --fish <($out/bin/svu completion fish) \
      --zsh <($out/bin/svu completion zsh)
  '';

  passthru.tests.version = testers.testVersion { package = svu; };

  meta = {
    description = "Semantic Version Util";
    homepage = "https://github.com/caarlos0/svu";
    maintainers = with lib.maintainers; [ caarlos0 ];
    license = lib.licenses.mit;
    mainProgram = "svu";
  };
})
