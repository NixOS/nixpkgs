{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubernetes-metrics-server";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "metrics-server";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-RITmujmqDGHhhX8uOxchJE1jrIIuuhrjB/GgDHwkmo8=";
  };

  vendorHash = "sha256-YaVO5WSm0JoCwJ+9FqxXkgt3jaSz6/LavtFi5OQn+Ao=";

  preCheck = ''
    # the e2e test breaks the sandbox, so let's skip that
    rm test/e2e_test.go
  '';

  meta = {
    homepage = "https://github.com/kubernetes-sigs/metrics-server";
    description = "Kubernetes container resource metrics collector";
    mainProgram = "metrics-server";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ eskytthe ];
  };
})
