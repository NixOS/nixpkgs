{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "gh";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    rev = "v${version}";
    sha256 = "14j8210c1dndnhb8l2ifxcljzhajjhil86lvk9y7ndjkq09805q1";
  };

  modSha256 = "1qwcl74sg5az9vaivnvn7f40p72ilmkms5rp52sp5imfrql81lxf";

  buildFlagsArray = [
    "-ldflags=-X github.com/cli/cli/command.Version=${version}"
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
