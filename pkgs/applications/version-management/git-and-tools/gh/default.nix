{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "gh";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    rev = "v${version}";
    sha256 = "03bsramq75i5sw08gdmjh94n1xh743mq6h4dzaix78i531x7y34i";
  };

  vendorSha256 = "0nk5axyr3nd9cbk8wswfhqf25dks22mky3rdn6ba9s0fpxhhkr5g";

  nativeBuildInputs = [ installShellFiles ];

  buildPhase = ''
    export GO_LDFLAGS="-s -w"
    make GH_VERSION=${version} bin/gh manpages
  '';

  installPhase = ''
    install -Dm755 bin/gh -t $out/bin
    installManPage share/man/*/*.[1-9]

    for shell in bash fish zsh; do
      $out/bin/gh completion -s $shell > gh.$shell
      installShellCompletion gh.$shell
    done
  '';

  # fails with `unable to find git executable in PATH`
  doCheck = false;

  meta = with lib; {
    description = "GitHub CLI tool";
    homepage = "https://cli.github.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ zowoq ];
  };
}
