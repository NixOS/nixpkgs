{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  aws-lc,
  openssl,
  tpm2-tss,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nitrotpm-tools";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "NitroTPM-Tools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+1uR2c5Xv+Y7IUGGbseXnRvc5TaZdf9RYB8X0EB9ZGg=";
  };

  cargoHash = "sha256-ZVZT/It9k3yjLKTEffN9+VjEf/JSiY+1MXjLmvkGXfc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    aws-lc
    tpm2-tss
  ];

  checkInputs = [ openssl ];

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
