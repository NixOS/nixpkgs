{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  tpm2-tss,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "nitrotpm-tools";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "NitroTPM-Tools";
    rev = "v${version}";
    hash = "sha256-ZTASHHa+LQ/hNaM0qfsaGdNwkZQQZnR9+f05DHbviLw=";
  };

  cargoHash = "sha256-z0b0bLKrnLdMfGKp9aIg3DPW3MJnEhjy9GjCYy44TTQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    tpm2-tss
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Collection of utilities for working with NitroTPM attestation";
    longDescription = ''
      A collection of utilities for working with NitroTPM attestation on AWS EC2.
      Includes nitro-tpm-attest for requesting attestation documents and
      nitro-tpm-pcr-compute for precomputing PCR values of UKIs (Unified Kernel Images).
    '';
    homepage = "https://github.com/aws/NitroTPM-Tools";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      arianvp
      mariusknaust
    ];
    platforms = lib.platforms.linux;
  };
}
