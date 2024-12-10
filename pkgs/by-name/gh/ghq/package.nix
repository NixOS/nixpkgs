{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ghq";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "x-motemen";
    repo = "ghq";
    rev = "v${version}";
    sha256 = "sha256-fL63e0URUiGkVLyLvNeXjIFYEjWF6Xd4FXFXrpqcduQ=";
  };

  vendorHash = "sha256-8n0kAowtBSCavHI6y3I7ozJg74tA8bF80WVwe+znHhc=";

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
