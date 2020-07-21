{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "gh";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    rev = "v${version}";
    sha256 = "13nq7rvxwl9cld9gng7rm534yqrr2ii0bqyzqwlkpzh9m61m3ra2";
  };

  vendorSha256 = "1xvrxdxhyj5nz5plypc5mniw5dl17w1wxcrs77w24hisn90jphgd";

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

  meta = with lib; {
    description = "GitHub CLI tool";
    homepage = "https://cli.github.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ zowoq ];
  };
}
