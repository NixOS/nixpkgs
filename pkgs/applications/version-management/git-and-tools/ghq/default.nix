{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ghq";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "x-motemen";
    repo = "ghq";
    rev = "v${version}";
    sha256 = "sha256-6oRyT/i+PndmjWBNJQzgrysE7jXiL/hAwwN++uCs6ZI=";
  };

  vendorSha256 = "sha256-5Eth9v98z1gxf1Fz5Lbn2roX7dSBmA7GRzg8uvT0hTI=";

  doCheck = false;

  buildFlagsArray = ''
    -ldflags=
      -X=main.Version=${version}
  '';

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
