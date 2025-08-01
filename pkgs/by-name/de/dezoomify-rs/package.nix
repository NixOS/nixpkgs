{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "dezoomify-rs";
  version = "2.15.0";

  src = fetchFromGitHub {
    owner = "lovasoa";
    repo = "dezoomify-rs";
    tag = "v${version}";
    hash = "sha256-gx/h9i+VPU0AtpQEkN/zCLmeyaW5wSUCfdY52hPwm3Q=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  passthru.updateScript = nix-update-script { };

  cargoHash = "sha256-Jh1a5DW25a4wzuZbOAoTn/crp/ioLsmq3jDiqIctCCM=";

  checkFlags = [
    # Tests failing due to networking errors in Nix build environment
    "--skip=local_generic_tiles"
    "--skip=custom_size_local_zoomify_tiles"
  ];

  meta = {
    description = "Zoomable image downloader for Google Arts & Culture, Zoomify, IIIF, and others";
    homepage = "https://github.com/lovasoa/dezoomify-rs/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fsagbuya ];
    mainProgram = "dezoomify-rs";
  };
}
