{ stdenv, fetchFromGitHub, buildGoModule, installShellFiles, Security }:

buildGoModule rec {
  pname = "gh";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    rev = "v${version}";
    sha256 = "10vylfsc8lldmr1l6r882sx87pgxl687k419c19faq90vd403i14";
  };

  modSha256 = "03m193ny5z77yy586cwh099ypi1lmhb5vdj7d4kphxycnvpndr66";

  buildFlagsArray = [
    "-ldflags=-X github.com/cli/cli/command.Version=${version}"
  ];

  subPackages = [ "cmd/gh" ];

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];
  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/gh completion -s $shell > gh.$shell
      installShellCompletion gh.$shell
    done
  '';

  meta = with stdenv.lib; {
    description = "GitHub CLI tool";
    homepage = "https://cli.github.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ zowoq ];
  };
}
