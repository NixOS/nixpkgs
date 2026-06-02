{
  buildGoModule,
  fetchFromGitHub,
  lib,
  yq-go,
  nix-update-script,
}:

let
  version = "1.1.1";
in
buildGoModule {
  pname = "helm-unittest";
  inherit version;

  src = fetchFromGitHub {
    owner = "helm-unittest";
    repo = "helm-unittest";
    tag = "v${version}";
    hash = "sha256-oiTW8F0yo+kN943MI2mR5uEEYbMVxJx4RdEislJ3XSo=";
  };

  vendorHash = "sha256-4ckjM520MGYb64LbjYURe7AIScm4aGbj81rGKSSYaAo=";

  patches = [ ./plugin-yaml-platformCommand-use-source-binary.patch ];

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
