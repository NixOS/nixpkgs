{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  tpm2-tss,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nitrotpm-tools";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "NitroTPM-Tools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Jnv1ZKRs59eXnW/O6UCZLIhQolQ9LZjJI6+SqXVws5Q=";
  };

  cargoHash = "sha256-ckygzrbDzzjL2eBktAHdbA40E7HDeR8S5rZCbbuVIW0=";

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
})
