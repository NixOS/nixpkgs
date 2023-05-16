<<<<<<< HEAD
{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, zlib
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "tickrs";
  version = "0.14.9";
=======
{ lib, stdenv, rustPlatform, fetchFromGitHub, perl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "tickrs";
  version = "0.14.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "tarkah";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-cN5GtU3bmsdJvfjVdWvWAshiU3Ged7L9pc8wid8GQwA=";
  };

  cargoHash = "sha256-ngDA085V3+2oBH13Fs+pJez2W2/i1pEKoWdqJ4/3Q0I=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };
=======
    hash = "sha256-8q/dL1Pv25TkL7PESybgIu+0lR0cr6qrK6ItE/r9pbI=";
  };

  cargoHash = "sha256-fOYxOiVpgflwIz9Z6ePhQKDa7DX4D/ZCnPOwq9vWOSk=";

  nativeBuildInputs = [ perl ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Realtime ticker data in your terminal";
    homepage = "https://github.com/tarkah/tickrs";
    changelog = "https://github.com/tarkah/tickrs/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ mredaelli ];
  };
}
