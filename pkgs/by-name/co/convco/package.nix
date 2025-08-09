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
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "convco";
    repo = "convco";
    rev = "v${version}";
    hash = "sha256-s0rcSekJLe99oxi6JD8VL1S6nqQTUFTn5pdgxnknbaY=";
  };

  cargoHash = "sha256-ClkpGHN2me+R3jX7S5hFR1FlsXGhHZ/y6iIGK08Mdfc=";

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
