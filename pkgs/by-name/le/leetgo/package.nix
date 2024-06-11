{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "leetgo";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "j178";
    repo = "leetgo";
    rev = "v${version}";
    hash = "sha256-LbY7GGPu2ZwcclCmsE9V421FUi+foR7CXyFHF7GrjQo=";
  };

  vendorHash = "sha256-GG9IfM50uVhsQVjXhUrYxuEbPlbsEsFubmUUSMr5SD4=";

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
