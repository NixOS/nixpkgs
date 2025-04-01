{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  kapp,
}:

buildGoModule rec {
  pname = "kapp";
  version = "0.63.3";

  src = fetchFromGitHub {
    owner = "carvel-dev";
    repo = "kapp";
    rev = "v${version}";
    hash = "sha256-mOXjPdeDJKBEW7Jr0yMFpZ4WBciJBh0s2AEMtog6CIw=";
  };

  vendorHash = null;

  subPackages = [ "cmd/kapp" ];

  CGO_ENABLED = 0;

  ldflags = [
    "-X carvel.dev/kapp/pkg/kapp/version.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/kapp completion $shell > kapp.$shell
      installShellCompletion kapp.$shell
    done
  '';

  passthru.tests.version = testers.testVersion {
    package = kapp;
  };

  meta = with lib; {
    description = "CLI tool that encourages Kubernetes users to manage bulk resources with an application abstraction for grouping";
    homepage = "https://carvel.dev/kapp/";
    license = licenses.asl20;
    maintainers = with maintainers; [ brodes ];
    mainProgram = "kapp";
  };
}
