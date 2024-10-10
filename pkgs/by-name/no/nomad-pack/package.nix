{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "nomad-pack";
  version = "nightly-2024-09-23";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "nomad-pack";
    rev = "3c0178a561b360906c591718edb25ae25ae9d964";  # nightly tag as of 2024-09-23
    hash = "sha256-8erw+8ZTpf8Dc9m6t5NeRgwOETkjXN/wVhoZ4g0uWhg=";
  };

  vendorHash = "sha256-Rt0T6cCMzO4YBFF6/9xeCZcsqziDmxPMNirHLqepwek=";

  # skip running go tests as they require network access
  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/nomad-pack --version
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/hashicorp/nomad-pack";
    changelog = "https://github.com/hashicorp/nomad-pack/blob/main/CHANGELOG.md";
    description = "Nomad Pack is a templating and packaging tool used with HashiCorp Nomad";
    license = licenses.mpl20;
    maintainers = with maintainers; [ techknowlogick ];
  };

}
