{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "dezoomify-rs";
  version = "2.12.4";

  src = fetchFromGitHub {
    owner = "lovasoa";
    repo = "dezoomify-rs";
    rev = "refs/tags/v${version}";
    hash = "sha256-7CRwlnIItJ89qqemkJbx5QjcLrwYrvpcjVYX5ZWP0W4=";
  };

  cargoHash = "sha256-v48eM43+/dt2M1J9yfjfTpBetv6AA2Hhzu8rrL3gojg=";

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
