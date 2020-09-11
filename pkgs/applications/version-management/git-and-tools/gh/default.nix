{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "gh";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    rev = "v${version}";
    sha256 = "1nwpqwr8sqqpndj7qsk935i1675f4qdbl31x60a038l9iiwc28x1";
  };

  vendorSha256 = "1m5ahzh5sfla3p6hllr7wjigvrnccdvrsdjpxd2hy0rl7jsrp85m";

  nativeBuildInputs = [ installShellFiles ];

  buildPhase = ''
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

  checkPhase = ''
    make test
  '';

  meta = with lib; {
    description = "GitHub CLI tool";
    homepage = "https://cli.github.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ zowoq ];
  };
}
