{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "helm-unittest";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-51Cx8V0cvuyBLFVmOWpA8X/kpDR67Q5EYZct44ED/ys=";
  };

  vendorHash = "sha256-6tXQ2fbn1ZzImx8luxetXHNj3gIUt217rjXJPxMpjTw=";

  # NOTE: Remove the install and upgrade hooks.
  postPatch = ''
    sed -i '/^hooks:/,+2 d' plugin.yaml
  '';

  postInstall = ''
    install -dm755 $out/${pname}
    mv $out/bin/helm-unittest $out/${pname}/untt
    rmdir $out/bin
    install -m644 -Dt $out/${pname} plugin.yaml
  '';

  meta = with lib; {
    description = "BDD styled unit test framework for Kubernetes Helm charts as a Helm plugin";
    homepage = "https://github.com/helm-unittest/helm-unittest";
    license = licenses.mit;
    maintainers = with maintainers; [ yurrriq ];
  };
}
