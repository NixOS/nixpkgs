{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "nomad-driver-podman";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "nomad-driver-podman";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Zxi3VNEPrGYibQSRfCxy7T85yJUyC8yLlJNnPfHq3UE=";
  };

  vendorHash = "sha256-QgKTk3HPsldu0SVIyVq18e7MMJlDUTTpzcd6NO0UNic=";

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
})
