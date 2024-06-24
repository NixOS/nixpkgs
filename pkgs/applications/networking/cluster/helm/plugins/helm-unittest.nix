{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "helm-unittest";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-YWzjv1/I+LX3AMeQenI36AsNJkZ6IzbMhM/f5/Kxs2M=";
  };

  vendorHash = "sha256-A2izHBh58yPd2XPm4GKVosPtahUtQ35GbyBdr/L13CQ=";

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
