{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, dbus
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "mprisence";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "lazykern";
    repo = "mprisence";
    rev = "v${version}";
    hash = "sha256-L9Zy0/kNBJf3LJ46Da7/FW8Dk9HKoSMaaYRa4NxjrLQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "A Discord Rich Presence client for MPRIS-compatible media players with support for album art";
    homepage = "https://github.com/lazykern/mprisence";
    license = licenses.mit;
    maintainers = with maintainers; [ iogamaster ];
    mainProgram = "mprisence";
  };
}
