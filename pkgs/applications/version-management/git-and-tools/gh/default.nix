{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "gh";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    rev = "v${version}";
    sha256 = "1i8zxz1vwr86654bxrb8ryh9mk3hsgyrkaxx17dnvasdvym49vrs";
  };

  modSha256 = "0ina3m2ixkkz2fws6ifwy34pmp6kn5s3j7w40alz6vmybn2smy1h";

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
    homepage = "https://github.com/cli/cli";
    license = licenses.mit;
    maintainers = with maintainers; [ zowoq ];
  };
}
