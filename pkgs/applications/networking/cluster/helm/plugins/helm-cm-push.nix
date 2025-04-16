{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "helm-cm-push";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "chartmuseum";
    repo = "helm-push";
    rev = "v${version}";
    hash = "sha256-YnhI1/BDk9swr3YFm5ajGf4LLgPty7blA2tlsMH0erY=";
  };

  vendorHash = "sha256-7bUDKqkvBV1Upcrj4DQnVCP74QtKlSwF0Kl2sPFZpjc=";

  subPackage = [ "cmd/helm-cm-push" ];

  # Remove hooks.
  postPatch = ''
    sed -e '/^hooks:/,+2 d' -i plugin.yaml
  '';

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    install -Dm644 plugin.yaml $out/helm-cm-push/plugin.yaml
    mv $out/bin $out/helm-cm-push
  '';

  # Tests require the ChartMuseum service.
  doCheck = false;

  meta = with lib; {
    description = "Helm plugin to push chart package to ChartMuseum";
    homepage = "https://github.com/chartmuseum/helm-push";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
