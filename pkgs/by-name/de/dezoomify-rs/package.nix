{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "dezoomify-rs";
  version = "2.12.5";

  src = fetchFromGitHub {
    owner = "lovasoa";
    repo = "dezoomify-rs";
    rev = "refs/tags/v${version}";
    hash = "sha256-PbtsrvNHo/SvToQJTTAPLoNDFotDPmSjr6C3IJZUjqU=";
  };

  cargoHash = "sha256-K9LNommagWjVxOXq6YUE4eg/3zpj3+MR5BugGCcVUlA=";

  buildInputs = lib.optionals stdenv.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      SystemConfiguration
    ]
  );

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
