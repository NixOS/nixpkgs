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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "Siriusmart";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-YQj+hmNh8rqP7bKeFDQhZIf79WG7vqg31oReb0jrmg4=";
  };

  cargoHash = "sha256-qcWuh8qaOQBBebdX3D01k5yXZfifbFC+ZP0d6bJeOr0=";

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
