{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "gh";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    rev = "v${version}";
    sha256 = "0bn7l1q1d85zg7za8bfz12wwz6ff17vwdsriazvhwia3a93g9ad0";
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
