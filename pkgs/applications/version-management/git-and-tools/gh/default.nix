{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "gh";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    rev = "v${version}";
    sha256 = "1q0vc9wr4n813mxkf7jjj3prw1n7xv4l985qd57pg4a2js1dqa1y";
  };

  vendorSha256 = "1wv30z0jg195nkpz3rwvhixyw81lg2wzwwajq9g6s3rfjj8gs9v2";

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
