{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, xorg
, stdenv
, python3
, libsixel
, CoreFoundation
, Security
, AppKit
,
}:

rustPlatform.buildRustPackage rec {
  pname = "youtube-tui";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "Siriusmart";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Dhdtdc8LmTeg9cxKPfdxRowTsAaJXKtvJXqJHK1t3P4=";
  };

  cargoHash = "sha256-hT3Ygn0zcQdU1iU22e5SP5ZF6S6GiZzWieBsCqViN8Y=";

  nativeBuildInputs = [
    pkg-config
    python3
  ];

  buildInputs = [
    openssl
    xorg.libxcb
    libsixel
  ] ++ lib.optionals stdenv.isDarwin [
    CoreFoundation
    Security
    AppKit
  ];

  meta = with lib; {
    description = "An aesthetically pleasing YouTube TUI written in Rust";
    homepage = "https://siriusmart.github.io/youtube-tui";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Ruixi-rebirth ];
  };
}
