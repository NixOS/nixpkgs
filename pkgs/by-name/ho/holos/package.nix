{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  holos,
  kubectl,
  kustomize,
  kubernetes-helm,
}:
buildGoModule rec {
  pname = "holos";
  version = "0.104.1";

  src = fetchFromGitHub {
    owner = "holos-run";
    repo = "holos";
    rev = "v${version}";
    hash = "sha256-4LCNKPf+b7O9DHCmOzaI8clCbmikyAAG+6C3I0aQdMg=";
  };

  vendorHash = "sha256-FR3H2NS4sEYjGmzIyaUglby98AgDAgbIzl9de8h/cj8=";

  ldflags = [
    "-w"
    "-X github.com/holos-run/holos/version.GitDescribe=v${version}"
    "-X github.com/holos-run/holos/version.GitCommit=${src.rev}"
    "-X github.com/holos-run/holos/version.GitTreeState=clean"
    # fix time for deterministic builds
    "-X github.com/holos-run/holos/version.BuildDate=1970-01-01T00:00:00Z"
  ];

  subPackages = [ "cmd/holos" ];

  nativeCheckInputs = [
    kubernetes-helm
    kubectl
    kustomize
  ];

  passthru.tests.version = testers.testVersion {
    package = holos;
    command = "holos --version || true";
    version = "${version}";
  };

  meta = with lib; {
    description = "Holos CLI tool";
    homepage = "https://github.com/holos-run/holos";
    license = licenses.asl20;
    maintainers = with maintainers; [ cameronraysmith ];
    mainProgram = "holos";
  };
}
