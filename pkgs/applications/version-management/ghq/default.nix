{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ghq";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "x-motemen";
    repo = "ghq";
    rev = "v${version}";
    sha256 = "sha256-tGublfC6EeY3T/45lxmsm5zsmlgq/guS64OutAWy6AY=";
  };

  vendorSha256 = "sha256-ZUnnvZERWXnOs4hybw8JDlGdM7QFaMfs6o3SYy0UwTM=";

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
