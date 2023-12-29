{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "helm-s3";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "hypnoglow";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-D79nUIueOV2FC3I2LreHMzl/xOpzNa+OsfL5wcnyY78=";
  };

  vendorHash = "sha256-dKKggD/VlBiopt2ygh07+6bTBbRgQfWbiY/1qJSSx/0=";

  # NOTE: Remove the install and upgrade hooks.
  postPatch = ''
    sed -i '/^hooks:/,+2 d' plugin.yaml
  '';

  # NOTE: make test-unit, but skip awsutil, which needs internet access
  checkPhase = ''
    go test $(go list ./... | grep -vE '(awsutil|e2e)')
  '';

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  subPackages = [ "cmd/helm-s3" ];

  postInstall = ''
    install -dm755 $out/${pname}
    mv $out/bin $out/${pname}/
    install -m644 -Dt $out/${pname} plugin.yaml
  '';

  meta = with lib; {
    description = "A Helm plugin that allows to set up a chart repository using AWS S3";
    homepage = "https://github.com/hypnoglow/helm-s3";
    license = licenses.mit;
    maintainers = with maintainers; [ yurrriq ];
  };
}
