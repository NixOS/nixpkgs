{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, madonctl }:

buildGoModule rec {
  pname = "madonctl";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "McKael";
    repo = "madonctl";
    rev = "v${version}";
    hash = "sha256-mo185EKjLkiujAKcAFM1XqkXWvcfYbnv+r3dF9ywaf8=";
  };

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    installShellCompletion --cmd madonctl \
      --bash <($out/bin/madonctl completion bash) \
      --zsh <($out/bin/madonctl completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = madonctl;
    command = "madonctl version";
  };

  meta = with lib; {
    description = "CLI for the Mastodon social network API";
    homepage = "https://github.com/McKael/madonctl";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "madonctl";
  };
}
