{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "convco";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "convco";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-s0rcSekJLe99oxi6JD8VL1S6nqQTUFTn5pdgxnknbaY=";
  };

  cargoHash = "sha256-oQBCPfwlMJ0hLZskv+KUNVBHH550yAUI1jY40Eah3Bc=";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ openssl ];

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
