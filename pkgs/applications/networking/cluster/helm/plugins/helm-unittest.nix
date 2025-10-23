{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "helm-unittest";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "helm-unittest";
    repo = "helm-unittest";
    rev = "v${version}";
    hash = "sha256-RWucFZlyVYV5pHFGP7x5I+SILAJ9k12R7l5o7WKGS/c=";
  };

  vendorHash = "sha256-tTM9n/ahtAJoQt0fwf1jrSokWER+cOnpPX7NTNrhKc4=";

  # NOTE: Remove the install and upgrade hooks.
  postPatch = ''
    sed -i '/^hooks:/,+2 d' plugin.yaml
  '';

  postInstall = ''
    install -dm755 $out/helm-unittest
    mv $out/bin/helm-unittest $out/helm-unittest/untt
    rmdir $out/bin
    install -m644 -Dt $out/helm-unittest plugin.yaml
  '';

  meta = with lib; {
    description = "BDD styled unit test framework for Kubernetes Helm charts as a Helm plugin";
    homepage = "https://github.com/helm-unittest/helm-unittest";
    license = licenses.mit;
    maintainers = with maintainers; [ yurrriq ];
  };
}
