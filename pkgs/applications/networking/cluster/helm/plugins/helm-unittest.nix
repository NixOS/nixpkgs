{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "helm-unittest";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-RgEYFTI1uaW1aTr+/lpKQ39o5CLsj/p0JeSTUXti/IM=";
  };

  vendorHash = "sha256-P0PVzgaUN9X9x77v1psV13vNl06HrHbdlA1YHCq/eCo=";

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
