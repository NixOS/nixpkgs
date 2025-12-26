{
  buildGoModule,
  fetchFromGitHub,
  lib,
  yq-go,
  nix-update-script,
}:

let
  version = "1.0.3";
in
buildGoModule {
  pname = "helm-unittest";
  inherit version;

  src = fetchFromGitHub {
    owner = "helm-unittest";
    repo = "helm-unittest";
    tag = "v${version}";
    hash = "sha256-wArRsC52ga485rpm8ns99NY/qUZ/FImK4C/L1q460HI=";
  };

  vendorHash = "sha256-dkAzmFvLbhbIYCKsk1+TfckdNkNh6OkpDabJDDSwXJM=";

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

  meta = {
    description = "BDD styled unit test framework for Kubernetes Helm charts as a Helm plugin";
    homepage = "https://github.com/helm-unittest/helm-unittest";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      booxter
      yurrriq
    ];
  };
}
