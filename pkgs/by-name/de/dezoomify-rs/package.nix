{
  lib,
  rustPlatform,
  fetchFromGitHub,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "dezoomify-rs";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "lovasoa";
    repo = "dezoomify-rs";
    tag = "v${version}";
    hash = "sha256-uo0QTaAAbNYMidlWBauW+3hdd0snEWH+I5KQL6Vxgug=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-v5hlG/VnRyU4lR84IXal5GmrAyfxJTjmwzRKRcfaSIY=";

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
