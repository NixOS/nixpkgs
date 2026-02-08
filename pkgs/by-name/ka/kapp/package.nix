{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  kapp,
}:

buildGoModule (finalAttrs: {
  pname = "kapp";
  version = "0.65.0";

  src = fetchFromGitHub {
    owner = "carvel-dev";
    repo = "kapp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-D46QgNzkCNg0GDsaN1GG0yuWbNeioIErYhbgjwMsTWA=";
  };

  vendorHash = null;

  subPackages = [ "cmd/kapp" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-X carvel.dev/kapp/pkg/kapp/version.Version=${finalAttrs.version}"
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

  meta = {
    description = "CLI tool that encourages Kubernetes users to manage bulk resources with an application abstraction for grouping";
    homepage = "https://carvel.dev/kapp/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ brodes ];
    mainProgram = "kapp";
  };
})
