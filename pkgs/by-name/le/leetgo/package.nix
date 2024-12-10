{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "leetgo";
  version = "1.4.10";

  src = fetchFromGitHub {
    owner = "j178";
    repo = "leetgo";
    rev = "v${version}";
    hash = "sha256-0cBhJfxzzZ5IrVVYNWVoKK9c1baj5U2CvDO52wdsjcs=";
  };

  vendorHash = "sha256-1/U+sPauV3kYvQKTGSuX9FvvEFNsksTPXtfZH0a/o0s=";

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
