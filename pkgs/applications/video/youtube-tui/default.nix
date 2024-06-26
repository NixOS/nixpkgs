{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  xorg,
  stdenv,
  python3,
  makeBinaryWrapper,
  libsixel,
  mpv,
  CoreFoundation,
  Security,
  AppKit,
}:

rustPlatform.buildRustPackage rec {
  pname = "youtube-tui";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "Siriusmart";
    repo = "youtube-tui";
    rev = "v${version}";
    hash = "sha256-FOiK3yQcQuwdCEjBtRPW4iBd+8uNsvZ6l5tclHVzL+M=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "libmpv-2.0.1" = "sha256-efbXk0oXkzlIqgbP4wKm7sWlVZBT2vzDSN3iwsw2vL0=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    python3
    makeBinaryWrapper
  ];

  buildInputs =
    [
      openssl
      xorg.libxcb
      libsixel
      mpv
    ]
    ++ lib.optionals stdenv.isDarwin [
      CoreFoundation
      Security
      AppKit
    ];

  # sixel-sys is dynamically linked to libsixel
  postInstall = lib.optionalString stdenv.isDarwin ''
    wrapProgram $out/bin/youtube-tui \
      --prefix DYLD_LIBRARY_PATH : "${lib.makeLibraryPath [ libsixel ]}"
  '';

  meta = with lib; {
    description = "Aesthetically pleasing YouTube TUI written in Rust";
    homepage = "https://siriusmart.github.io/youtube-tui";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Ruixi-rebirth ];
    mainProgram = "youtube-tui";
  };
}
