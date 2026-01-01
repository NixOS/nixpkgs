{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "nomad-pack";
<<<<<<< HEAD
  version = "0.4.1";
=======
  version = "0.4.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "nomad-pack";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-nKhiI7VizNTqB5r+Ayp7tDNd2eWtsFvnoB798W0cRi4=";
  };

  vendorHash = "sha256-iVmJf2nxpj5oF00lFTzVSjMooFipo0IGqvVVGI1Mfwc=";
=======
    sha256 = "sha256-9lkRDRXY27KzVAClDfqtD95OMsMPgTqvDesr6qHsNkM=";
  };

  vendorHash = "sha256-laCCm+WluxfsYtpTu5RvKy40UBZkkvLgVbWbdRjfAhU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # skip running go tests as they require network access
  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/nomad-pack --version
    runHook postInstallCheck
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/hashicorp/nomad-pack";
    changelog = "https://github.com/hashicorp/nomad-pack/blob/main/CHANGELOG.md";
    description = "Nomad Pack is a templating and packaging tool used with HashiCorp Nomad";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ techknowlogick ];
=======
  meta = with lib; {
    homepage = "https://github.com/hashicorp/nomad-pack";
    changelog = "https://github.com/hashicorp/nomad-pack/blob/main/CHANGELOG.md";
    description = "Nomad Pack is a templating and packaging tool used with HashiCorp Nomad";
    license = licenses.mpl20;
    maintainers = with maintainers; [ techknowlogick ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

}
