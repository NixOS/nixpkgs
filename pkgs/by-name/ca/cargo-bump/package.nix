{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, stdenv
, darwin
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

  cargoHash = "sha256-mp2y5q0GYfSlB5aPC6MY9Go8a2JAiPKtVYL9SewfloI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Increments the version number of the current project.";
    homepage = "https://github.com/wraithan/cargo-bump";
    license = with licenses; [ isc ];
    maintainers = with maintainers; [ cafkafk ];
  };
}
