{
  buildGoModule,
  fetchFromGitHub,
  lib,
  yq-go,
  nix-update-script,
}:

buildGoModule rec {
  pname = "helm-unittest";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "helm-unittest";
    repo = "helm-unittest";
    rev = "v${version}";
    hash = "sha256-bdLxW6dkA+jdn6UVOGngP3U0Do1zZt3Tnb9d6yVOGG0=";
  };

  vendorHash = "sha256-kiQRttnXgcTAElPlggkk11BGilcA+hG8doMq5eAmH6Q=";

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

  nativeCheckInputs = [
    yq-go
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "BDD styled unit test framework for Kubernetes Helm charts as a Helm plugin";
    homepage = "https://github.com/helm-unittest/helm-unittest";
    license = licenses.mit;
    maintainers = with maintainers; [ yurrriq ];
  };
}
