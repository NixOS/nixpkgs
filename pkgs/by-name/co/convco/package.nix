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
<<<<<<< HEAD
  version = "0.6.2";
=======
  version = "0.6.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "convco";
    repo = "convco";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-giVaDOYYH3YE9Gy0byt92vGEfyM4rTjpHDsKm5lqlP4=";
  };

  cargoHash = "sha256-DTeZDpS3OaGcem9AaAPFN+2AWuqWSGfk2KknbcgFzi0=";
=======
    hash = "sha256-s0rcSekJLe99oxi6JD8VL1S6nqQTUFTn5pdgxnknbaY=";
  };

  cargoHash = "sha256-ClkpGHN2me+R3jX7S5hFR1FlsXGhHZ/y6iIGK08Mdfc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
    "--skip=git::tests::test_find_matching_prerelease"
    "--skip=git::tests::test_find_matching_prerelease_without_matching_release"
  ];

  meta = {
    description = "Conventional commit cli";
    mainProgram = "convco";
    homepage = "https://github.com/convco/convco";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
=======
  ];

  meta = with lib; {
    description = "Conventional commit cli";
    mainProgram = "convco";
    homepage = "https://github.com/convco/convco";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      hoverbear
      cafkafk
    ];
  };
}
