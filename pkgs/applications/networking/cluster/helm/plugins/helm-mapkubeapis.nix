{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "helm-mapkubeapis";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "helm";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OIom+fMjLkbYXbxCsISuihdr3CWjUnkucTnDfoix9B0=";
  };

  vendorHash = "sha256-jqVzBRlGFhDHaiSF9AArJdt4KRCiUqUuo0CnJUTbSfE=";

  # NOTE: Remove the install and upgrade hooks.
  postPatch = ''
    sed -i '/^hooks:/,+2 d' plugin.yaml
  '';

  checkPhase = ''
  '';

  postInstall = ''
    install -dm755 $out/${pname}
    mv $out/bin $out/${pname}/
    install -m644 -Dt $out/${pname}/config/ config/Map.yaml
    install -m644 -Dt $out/${pname} plugin.yaml
  '';

  meta = with lib; {
    description = "A Helm plugin to map helm release deprecated Kubernetes APIs in-place";
    homepage = "https://github.com/helm/helm-mapkubeapis";
    license = licenses.asl20;
    maintainers = with maintainers; [ flokli ];
  };
}
