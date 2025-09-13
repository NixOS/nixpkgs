{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  gambit-chess,
}:

buildGoModule rec {
  pname = "gambit";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "maaslalani";
    repo = "gambit";
    rev = "v${version}";
    hash = "sha256-RLbD9JK1yJn30WWg7KWDjJoj4WXIoy3Kb8t2F8rFPuk=";
  };

  vendorHash = "sha256-d9fPlv+ZAzQA42I61B5JEzfYpfJc9vWBcLYTX/s5dhs=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=v${version}"
    "-X=main.CommitSHA=${src.rev}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd gambit \
      --bash <($out/bin/gambit completion bash) \
      --fish <($out/bin/gambit completion fish) \
      --zsh <($out/bin/gambit completion zsh)
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = gambit-chess;
      version = "v${version}";
    };
  };

  meta = with lib; {
    description = "Play chess in your terminal";
    mainProgram = "gambit";
    homepage = "https://github.com/maaslalani/gambit";
    changelog = "https://github.com/maaslalani/gambit/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
