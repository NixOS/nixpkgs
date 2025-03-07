{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "leetgo";
  version = "1.4.7";

  src = fetchFromGitHub {
    owner = "j178";
    repo = "leetgo";
    rev = "v${version}";
    hash = "sha256-K/PaQakX0ZLu2Uh906kZ4p8J+GV7ewAeSVFMMQiKYBA=";
  };

  vendorHash = "sha256-4QSfZzYLjPdGKLySP57fK9n6WXdCYzb3sWibfP85jLE=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/j178/leetgo/constants.Version=${version}"
  ];

  subPackages = [ "." ];

  postInstall = ''
    installShellCompletion --cmd leetgo \
      --bash <($out/bin/leetgo completion bash) \
      --fish <($out/bin/leetgo completion fish) \
      --zsh <($out/bin/leetgo completion zsh)
  '';

  meta = with lib; {
    description = "A command-line tool for LeetCode";
    homepage = "https://github.com/j178/leetgo";
    changelog = "https://github.com/j178/leetgo/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Ligthiago ];
    mainProgram = "leetgo";
  };
}
