{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ghq";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "x-motemen";
    repo = "ghq";
    rev = "v${version}";
    sha256 = "sha256-gSMSn7YuhV/m5po+nu9Z/bxSRKg7/fXbF1stm7JQqZI=";
  };

  vendorHash = "sha256-M9B19rSEMnmT4wfOVnSAK06UPR/xrs0252lX3B9ebF8=";

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
    mainProgram = "ghq";
  };
}
