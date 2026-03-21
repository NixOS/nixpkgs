{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "nomad-driver-podman";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "nomad-driver-podman";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-fgJzlSJA2SMQU3aMUMoQEcVfkdPm5c8twWi97fxFQ3s=";
  };

  vendorHash = "sha256-+pc4Rnsh7Ku2IVptzq5UHB5wR9fvs+8K/d13M+hNRVI=";

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
