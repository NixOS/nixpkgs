{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "leetgo";
  version = "1.4.16";

  src = fetchFromGitHub {
    owner = "j178";
    repo = "leetgo";
    rev = "v${version}";
    hash = "sha256-rhMEeVkH9Z0pvtOtxooZKaiIQYyc067vqdSB9SIvqxg=";
  };

  vendorHash = "sha256-nKGLjpxtjcoR1mO1/ZhDoLubzfkws2nE5qvk2jqYGf4=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/j178/leetgo/constants.Version=${version}"
  ];

  subPackages = [ "." ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd leetgo \
      --bash <($out/bin/leetgo completion bash) \
      --fish <($out/bin/leetgo completion fish) \
      --zsh <($out/bin/leetgo completion zsh)
  '';

  meta = {
    description = "Command-line tool for LeetCode";
    homepage = "https://github.com/j178/leetgo";
    changelog = "https://github.com/j178/leetgo/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Ligthiago ];
    mainProgram = "leetgo";
  };
}
