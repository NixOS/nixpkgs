{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "gh";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    rev = "v${version}";
    sha256 = "0wqc9c30iydwylw53idff1ny2v410jcbhn7hpiinc4x5m3dy7827";
  };

  modSha256 = "191ds0dkllc0l2lbqnwlca26js90b2g9f70jsid0zhmz3z9f1zh9";

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
