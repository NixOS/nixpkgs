{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  darwin,
  alsa-lib,
  udev,
}:
rustPlatform.buildRustPackage rec {
  pname = "bevy_skein";
  version = "0.2.0-rc.1";
  src = fetchFromGitHub {
    owner = "rust-adventure";
    repo = "skein";
    rev = "main";
    hash = "sha256-OjOb+bAWApHIjt4EsfM/fscB7T5chArRuUGb5RbYuTk=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      # You'll need to add output hashes for any git dependencies here
    };
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.isLinux [
      alsa-lib
      udev
    ] # Add ALSA for Linux
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  meta = with lib; {
    description = "Convert glTF extras to Bevy Components using reflection";
    homepage = "https://github.com/rust-adventure/skein";
    license = licenses.mit;
    maintainers = with maintainers; [ guelakais ];
    platforms = platforms.all;
  };
}
