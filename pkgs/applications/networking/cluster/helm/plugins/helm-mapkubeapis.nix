{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "helm-mapkubeapis";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "helm";
    repo = "helm-mapkubeapis";
    rev = "v${version}";
    hash = "sha256-SYNCzVGGeuRj0PoOKU+1zydvAXVg4gUpIsqBTGChOgE=";
  };

  vendorHash = "sha256-G3Q8XCwKLgHeWLF46C5lWfvuynr/cJbkq7xdydfTHZ4=";

  # NOTE: Remove the install and upgrade hooks.
  postPatch = ''
    sed -i '/^hooks:/,+2 d' plugin.yaml
  '';

  postInstall = ''
    install -dm755 $out/helm-mapkubeapis
    mv $out/bin $out/helm-mapkubeapis/
    install -m644 -Dt $out/helm-mapkubeapis/config/ config/Map.yaml
    install -m644 -Dt $out/helm-mapkubeapis plugin.yaml
  '';

  meta = {
    description = "Helm plugin which maps deprecated or removed Kubernetes APIs in a release to supported APIs";
    homepage = "https://github.com/helm/helm-mapkubeapis";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ aos ];
  };
}
