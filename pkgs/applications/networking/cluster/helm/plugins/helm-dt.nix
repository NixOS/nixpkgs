{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "helm-dt";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "vmware-labs";
    repo = "distribution-tooling-for-helm";
    rev = "refs/tags/v${version}";
    hash = "sha256-jSX18FJCQORHFIUBROWZqAO5EBPXFvN/k0NRfkdkUFM=";
  };

  vendorHash = "sha256-8HefE1a3pcbBgq/bC0mnhWzSa5xTi2dbqw0tyJ9EyTI=";

  ldflags = [
    "-s"
    "-w"
    "-X 'main.BuildDate=1970-01-01 00:00:00 UTC'"
    "-X 'main.Commit=v${version}'"
  ];

  # NOTE: Remove the install and upgrade hooks.
  postPatch = ''
    sed -i '/^hooks:/,+2 d' plugin.yaml
  '';

  # require network/login
  doCheck = false;
  env.CGO_ENABLED = 1;

  postInstall = ''
    install -dm755 $out/helm-dt/bin
    mv $out/bin/dt $out/helm-dt/bin/dt
    rmdir $out/bin
    install -m644 -Dt $out/helm-dt plugin.yaml
  '';

  meta = {
    description = "Helm Distribution plugin is is a set of utilities and Helm Plugin for making offline work with Helm Charts easier";
    homepage = "https://github.com/vmware-labs/distribution-tooling-for-helm";
    maintainers = with lib.maintainers; [ ascii17 ];
    license = lib.licenses.mit;
  };
}
