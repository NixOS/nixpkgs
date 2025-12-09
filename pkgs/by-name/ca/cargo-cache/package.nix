{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-cache";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "matthiaskrgr";
    repo = "cargo-cache";
    tag = version;
    sha256 = "sha256-q9tYKXK8RqiqbDZ/lTxUI1Dm/h28/yZR8rTQuq+roZs=";
  };

  cargoHash = "sha256-cwTHJ5Cd17ur8AhEQb8FTS0mcgqg83VGjvCQP00JY6s=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    zlib
  ];

  checkFlags = [ "offline_tests" ];

  meta = with lib; {
    description = "Manage cargo cache (\${CARGO_HOME}, ~/.cargo/), print sizes of dirs and remove dirs selectively";
    mainProgram = "cargo-cache";
    homepage = "https://github.com/matthiaskrgr/cargo-cache";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      matthiasbeyer
    ];
  };
}
