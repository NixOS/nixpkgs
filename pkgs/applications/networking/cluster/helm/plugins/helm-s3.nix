{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "helm-s3";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "hypnoglow";
    repo = "helm-s3";
    rev = "v${version}";
    hash = "sha256-9n/Dzgr/wYGgJq47FdNGPPpOFzTRt4VaK8HA06F5FIE=";
  };

  vendorHash = "sha256-6YBIUUIvQ6ZDPF9Dz5tNXuHS+pa/yiNs4sKZbMudMxs=";

  # NOTE: Remove the install and upgrade hooks.
  postPatch = ''
    sed -i '/^hooks:/,+2 d' plugin.yaml
  '';

  # NOTE: make test-unit, but skip awsutil, which needs internet access
  checkPhase = ''
    go test $(go list ./... | grep -vE '(awsutil|e2e)')
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  subPackages = [ "cmd/helm-s3" ];

  postInstall = ''
    install -dm755 $out/helm-s3
    mv $out/bin $out/helm-s3/
    install -m644 -Dt $out/helm-s3 plugin.yaml
  '';

  meta = with lib; {
    description = "Helm plugin that allows to set up a chart repository using AWS S3";
    homepage = "https://github.com/hypnoglow/helm-s3";
    license = licenses.mit;
    maintainers = with maintainers; [ yurrriq ];
  };
}
