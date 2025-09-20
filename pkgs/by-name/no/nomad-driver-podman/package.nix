{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nomad-driver-podman";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "nomad-driver-podman";
    rev = "v${version}";
    sha256 = "sha256-foGbOIR1pdimMKVVrnvffNfqcWDwomenxtE696I1KwE=";
  };

  vendorHash = "sha256-nQTxadv2EBf4U0dXQXXAetqk9SzB8s+WyU9nRD+I438=";

  subPackages = [ "." ];

  # some tests require a running podman service
  doCheck = false;

  meta = {
    homepage = "https://www.github.com/hashicorp/nomad-driver-podman";
    description = "Podman task driver for Nomad";
    mainProgram = "nomad-driver-podman";
    platforms = lib.platforms.linux;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ cpcloud ];
  };
}
