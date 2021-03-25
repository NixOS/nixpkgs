{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "gh";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    rev = "v${version}";
    sha256 = "0ndi264rrssqin03qmv7n0fpzs3kasfqykidrlcyizw1ngyfgc1a";
  };

  vendorSha256 = "0ywh5d41b1c5ivwngsgn46d6yb7s1wqyzl5b0j1x4mcvydi5yi98";

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
