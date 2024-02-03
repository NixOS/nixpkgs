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

  src = fetchFromGitHub {
    owner = "NerdyPepper";
    repo = pname;
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
  };
}
