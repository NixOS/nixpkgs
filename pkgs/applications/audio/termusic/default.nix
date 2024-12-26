{
  alsa-lib,
  AppKit,
  CoreAudio,
  CoreGraphics,
  dbus,
  Foundation,
  fetchFromGitHub,
  fetchpatch,
  glib,
  gst_all_1,
  IOKit,
  lib,
  MediaPlayer,
  mpv-unwrapped,
  openssl,
  pkg-config,
  protobuf,
  rustPlatform,
  Security,
  sqlite,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "termusic";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "tramhao";
    repo = "termusic";
    rev = "v${version}";
    hash = "sha256-aEkg1j6R86QGn21HBimtZwmjmW1K9Wo+67G4DlpY960=";
  };

  cargoPatches = [
    # both following patches can be removed with the follow up release to 0.9.1 as they are cherry-picked from `termusic/master` branch
    # fix build issue with 0.9.1 release and vendoring producing wrong hash for soundtouch-ffi
    (fetchpatch {
      url = "https://github.com/tramhao/termusic/commit/211fc3fe008932d052d31d3b836e8a80eade3cfe.patch";
      hash = "sha256-11kSI28YonoTe5W31+R76lGhNiN1ZLAg94FrfYiZUAY=";
    })
    # fix a bug through previous patch
    (fetchpatch {
      url = "https://github.com/tramhao/termusic/commit/2a40b2f366dfa5c1f008c79a3ff5c1bbf53fe10f.patch";
      hash = "sha256-b7CJ5SqxrU1Jr4GDaJe9sFutDHMqIQxGhXbBFGB6y84=";
    })
  ];

  postPatch = ''
    pushd $cargoDepsCopy/stream-download
    oldHash=$(sha256sum src/lib.rs | cut -d " " -f 1)
    substituteInPlace $cargoDepsCopy/stream-download/src/lib.rs \
      --replace-warn '#![doc = include_str!("../README.md")]' ""
    substituteInPlace .cargo-checksum.json \
      --replace-warn $oldHash $(sha256sum src/lib.rs | cut -d " " -f 1)
    popd
  '';

  cargoHash = "sha256-4PprZdTIcYa8y7FwQVrG0ZBg7N/Xe6HDt/z6ZmaHd5Y=";

  useNextest = true;

  nativeBuildInputs = [
    pkg-config
    protobuf
    rustPlatform.bindgenHook
  ];

  buildInputs =
    [
      dbus
      glib
      gst_all_1.gstreamer
      mpv-unwrapped
      openssl
      sqlite
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      AppKit
      CoreAudio
      CoreGraphics
      Foundation
      IOKit
      MediaPlayer
      Security
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
    ];

  meta = {
    description = "Terminal Music Player TUI written in Rust";
    homepage = "https://github.com/tramhao/termusic";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ devhell ];
    mainProgram = "termusic";
  };
}
