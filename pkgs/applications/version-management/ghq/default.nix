{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ghq";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "x-motemen";
    repo = "ghq";
    rev = "v${version}";
    sha256 = "sha256-ggTx5Kz9cRqOqxxzERv4altf7m1GlreGgOiYCnHyJks=";
  };

  vendorHash = "sha256-6ZDvU3RQ/1M4DZMFOaQsEuodldB8k+2thXNhvZlVQEg=";

  doCheck = false;

  ldflags = [
    "-X=main.Version=${version}"
  ];

  postInstall = ''
    install -m 444 -D ${src}/misc/zsh/_ghq $out/share/zsh/site-functions/_ghq
    install -m 444 -D ${src}/misc/bash/_ghq $out/share/bash-completion/completions/_ghq
  '';

  meta = {
    description = "Remote repository management made easy";
    homepage = "https://github.com/x-motemen/ghq";
    maintainers = with lib.maintainers; [ sigma ];
    license = lib.licenses.mit;
  };
}
