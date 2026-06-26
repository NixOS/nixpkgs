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
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "NitroTPM-Tools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SL0I1bMh9QmBo4aBv1ZL3M5ZaVeJ0K3kZCMStma6bG0=";
  };

  cargoHash = "sha256-/2Lo5/CCv12PJocUYjZiRD4uBxrcKWA5RelLnU4TpcQ=";

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
