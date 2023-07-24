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
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "Siriusmart";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-UN70V+RGYlYJxCQGPH8cnQDSqpihGuwzETYEhbG6Ggo=";
  };

  cargoHash = "sha256-kAhxsSFIJAoKlmN7hVUoTSSHQ2G23f21rEvxcIRQ+kw=";

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
