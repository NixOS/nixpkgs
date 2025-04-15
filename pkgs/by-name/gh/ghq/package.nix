{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  nix-update-script,
  ghq,
}:

buildGoModule rec {
  pname = "ghq";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "x-motemen";
    repo = "ghq";
    tag = "v${version}";
    sha256 = "sha256-5BN96/RShfJpkfpJe0qrZVDuyFoAV9kgCiBv4REY/5Y=";
  };

  vendorHash = "sha256-jP2Ne/EhmE3tACY1+lHucgBt3VnT4gaQisE3/gVM5Ec=";

  doCheck = false;

  ldflags = [
    "-X=main.Version=${version}"
  ];

  postInstall = ''
    install -m 444 -D ${src}/misc/zsh/_ghq $out/share/zsh/site-functions/_ghq
    install -m 444 -D ${src}/misc/bash/_ghq $out/share/bash-completion/completions/_ghq
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = ghq;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Remote repository management made easy";
    homepage = "https://github.com/x-motemen/ghq";
    maintainers = with lib.maintainers; [ sigma ];
    license = lib.licenses.mit;
    mainProgram = "ghq";
  };
}
