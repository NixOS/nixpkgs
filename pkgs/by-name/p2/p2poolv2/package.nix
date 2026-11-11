{
  pkgs,
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  pname = "p2poolv2";
  version = "v0.16.2";
  useNextest = true;

  cargoTestFlags = [ "--no-fail-fast" ];

  src = fetchFromGitHub {
    owner = "p2poolv2";
    repo = "p2poolv2";
    tag = "${finalAttrs.version}";
    hash = "sha256-l+7nST2oPbVS+zkRoofDJgRRAp+hmZgNm63D7NHUgz4=";
  };

  cargoHash = "sha256-9lBi0EOf7hV3gpLUCVp2/ZKCGp64e41/vmmivNRjFI8=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkgs.pkg-config
    pkgs.openssl
    pkgs.cacert
  ];

  buildInputs = with pkgs; [
    aws-lc
    zstd
  ];

  meta = {
    description = "Peer-to-peer Bitcoin mining pool where miners coordinate directly and verify their rewards without centralized operators";
    license = with lib.licenses; [
      asl20 # apache 2.0
      mit
    ];

    maintainers = with lib.maintainers; [
      adevries17
      msgilligan
    ];
    mainProgram = "p2poolv2";
  };
})
