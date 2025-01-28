{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "fw";
  version = "2.20.0";

  src = fetchFromGitHub {
    owner = "brocode";
    repo = "fw";
    rev = "v${version}";
    hash = "sha256-bq8N49qArdF0EFIGiK4lCsC0CZxwmeo0R8OiehrifTg=";
  };

  cargoHash = "sha256-NnN1VT0odq+Qj2wIPIF3ZRObObyqlPknQais5e0SnKE=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      libgit2
      openssl
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = with lib; {
    description = "Workspace productivity booster";
    homepage = "https://github.com/brocode/fw";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "fw";
  };
}
