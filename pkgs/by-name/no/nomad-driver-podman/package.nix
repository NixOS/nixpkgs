{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nomad-driver-podman";
<<<<<<< HEAD
  version = "0.6.4";
=======
  version = "0.6.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "nomad-driver-podman";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-fgJzlSJA2SMQU3aMUMoQEcVfkdPm5c8twWi97fxFQ3s=";
  };

  vendorHash = "sha256-+pc4Rnsh7Ku2IVptzq5UHB5wR9fvs+8K/d13M+hNRVI=";
=======
    sha256 = "sha256-foGbOIR1pdimMKVVrnvffNfqcWDwomenxtE696I1KwE=";
  };

  vendorHash = "sha256-nQTxadv2EBf4U0dXQXXAetqk9SzB8s+WyU9nRD+I438=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  subPackages = [ "." ];

  # some tests require a running podman service
  doCheck = false;

<<<<<<< HEAD
  meta = {
    homepage = "https://www.github.com/hashicorp/nomad-driver-podman";
    description = "Podman task driver for Nomad";
    mainProgram = "nomad-driver-podman";
    platforms = lib.platforms.linux;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ cpcloud ];
=======
  meta = with lib; {
    homepage = "https://www.github.com/hashicorp/nomad-driver-podman";
    description = "Podman task driver for Nomad";
    mainProgram = "nomad-driver-podman";
    platforms = platforms.linux;
    license = licenses.mpl20;
    maintainers = with maintainers; [ cpcloud ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
