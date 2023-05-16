<<<<<<< HEAD
{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, ncurses
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "taizen";
  version = "unstable-2023-06-05";
=======
{ rustPlatform, lib, fetchFromGitHub, ncurses, openssl, pkg-config, Security, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "taizen";
  version = "0.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "NerdyPepper";
    repo = pname;
<<<<<<< HEAD
    rev = "5486cd4f4c5aa4e0abbcee180ad2ec22839abd31";
    hash = "sha256-pGcD3+3Ds3U8NuNySaDnz0zzAvZlSDte1jRPdM5qrZA=";
  };

  cargoHash = "sha256-2X9ZhqaQ6Y+mwXTMbvBQWLR24+KYYqjIqQy/8XqGi18=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    ncurses
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "curses based mediawiki browser";
    homepage = "https://github.com/nerdypepper/taizen";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
=======
    rev = "5c1876429e2da7424e9d31b1e16f5a3147cc58d0";
    sha256 = "09izgx7icvizskdy9kplk0am61p7550fsd0v42zcihq2vap2j92z";
  };

  buildInputs = [ ncurses openssl ] ++ lib.optional stdenv.isDarwin Security;
  nativeBuildInputs = [ pkg-config ];

  cargoSha256 = "1yqy5v02a4qshgb7k8rnn408k3n6qx3jc8zziwvv7im61n9sjynf";

  meta = with lib; {
    homepage = "https://crates.io/crates/taizen";
    license = licenses.mit;
    description = "curses based mediawiki browser";
    maintainers = with maintainers; [ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
