{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  libiconv,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "convco";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "convco";
    repo = "convco";
    rev = "v${version}";
    hash = "sha256-giVaDOYYH3YE9Gy0byt92vGEfyM4rTjpHDsKm5lqlP4=";
  };

  cargoHash = "sha256-DTeZDpS3OaGcem9AaAPFN+2AWuqWSGfk2KknbcgFzi0=";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  checkFlags = [
    # disable test requiring networking
    "--skip=git::tests::test_find_last_unordered_prerelease"
    "--skip=git::tests::test_find_matching_prerelease"
    "--skip=git::tests::test_find_matching_prerelease_without_matching_release"
  ];

  meta = with lib; {
    description = "Conventional commit cli";
    mainProgram = "convco";
    homepage = "https://github.com/convco/convco";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [
      hoverbear
      cafkafk
    ];
  };
}
