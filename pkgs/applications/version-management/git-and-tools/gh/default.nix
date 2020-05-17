{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "gh";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    rev = "v${version}";
    sha256 = "08fy3677yq52x40rab49ijhw4r25ls2807dbv9wpna6w07n7r8v7";
  };

  modSha256 = "0v33x9bnwjfg4425vralnsb4i22c0g1rcmaga9911v0i7d51k0fn";

  buildFlagsArray = [
    "-ldflags=-s -w -X github.com/cli/cli/command.Version=${version}"
  ];

  subPackages = [ "cmd/gh" ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/gh completion -s $shell > gh.$shell
      installShellCompletion gh.$shell
    done
  '';

  meta = with lib; {
    description = "GitHub CLI tool";
    homepage = "https://cli.github.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ zowoq ];
  };
}
