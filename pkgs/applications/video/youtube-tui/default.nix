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
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "Siriusmart";
    repo = "youtube-tui";
    tag = "v${version}";
    hash = "sha256-PAQkFg9SV6q3No5drYPPJZXzQ/XqtOhMr3eQOCnM+7Q=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-AjqxuNEyuDkYYuvi6Oii3/BfKFNUoJiBH4cS8cb7yMs=";

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
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      CoreFoundation
      Security
      AppKit
    ];

  # sixel-sys is dynamically linked to libsixel
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
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
