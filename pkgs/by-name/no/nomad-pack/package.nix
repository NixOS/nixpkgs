{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "nomad-pack";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "nomad-pack";
    rev = "v${version}";
    sha256 = "sha256-nKhiI7VizNTqB5r+Ayp7tDNd2eWtsFvnoB798W0cRi4=";
  };

  vendorHash = "sha256-iVmJf2nxpj5oF00lFTzVSjMooFipo0IGqvVVGI1Mfwc=";

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
