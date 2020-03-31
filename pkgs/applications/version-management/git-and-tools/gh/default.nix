{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "gh";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    rev = "v${version}";
    sha256 = "0h9ayz903hyc5k7fs278rbi2x5pzilwpk30fkc8cclbbcsfnk4ka";
  };

  modSha256 = "102v30wr9wmd6n20qdvgs5mp2s639pwbqqd71r8q52f42p694bi1";

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
