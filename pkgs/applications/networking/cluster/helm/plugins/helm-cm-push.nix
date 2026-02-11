{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "helm-cm-push";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "chartmuseum";
    repo = "helm-push";
    rev = "v${version}";
    hash = "sha256-0HskUSj1+5YZMLb0OMMhkNfN7J36GzE5Rdd9uLTO1Ys=";
  };

  vendorHash = "sha256-W7nWiWCLrzevunxYoDAqVbG5LhG+VXCAeI1D78fQQvw=";

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

  meta = {
    description = "Helm plugin to push chart package to ChartMuseum";
    homepage = "https://github.com/chartmuseum/helm-push";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
