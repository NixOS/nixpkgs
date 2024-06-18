{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "pio";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "siiptuo";
    repo = "pio";
    rev = version;
    hash = "sha256-iR6G+G1UOT1ThLI3yhz3na1HmN6z2qUiI6NSKT0krtY=";
  };

  cargoHash = "sha256-jVOpk+Z3yEEoDexvxT9I0aVHJKVq47y8km/9ltoqrDA=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Accelerate
  ];

  meta = with lib; {
    description = "Utility to compress image files while maintaining quality";
    homepage = "https://github.com/siiptuo/pio";
    changelog = "https://github.com/siiptuo/pio/blob/${version}/CHANGELOG.md";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ liassica ];
    mainProgram = "pio";
  };
}
