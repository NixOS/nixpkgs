{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bump";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "rustadopt";
    repo = "cargo-bump";
    rev = "v${version}";
    hash = "sha256-PhA7uC2gJcBnUQPWgZC51p/KTSxSGld3m+dd6BhW6q8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-5UyG/zGF+D5DOYWLiJPnGjAsr7e8xz+e4YUoZYerz80=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Increments the version number of the current project";
    mainProgram = "cargo-bump";
    homepage = "https://github.com/wraithan/cargo-bump";
    license = with licenses; [ isc ];
    maintainers = with maintainers; [ cafkafk ];
  };
}
