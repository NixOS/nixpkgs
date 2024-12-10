{
  alsa-lib,
  AppKit,
  CoreAudio,
  CoreGraphics,
  dbus,
  Foundation,
  fetchFromGitHub,
  glib,
  gst_all_1,
  IOKit,
  lib,
  MediaPlayer,
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
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "tramhao";
    repo = "termusic";
    rev = "v${version}";
    hash = "sha256-FOFZg32hrWpKVsjkMDkiqah7jmUZw0HRWGqOvsN0t8Q=";
  };

  postPatch = ''
    pushd $cargoDepsCopy/stream-download
    oldHash=$(sha256sum src/lib.rs | cut -d " " -f 1)
    substituteInPlace $cargoDepsCopy/stream-download/src/lib.rs \
      --replace-warn '#![doc = include_str!("../README.md")]' ""
    substituteInPlace .cargo-checksum.json \
      --replace $oldHash $(sha256sum src/lib.rs | cut -d " " -f 1)
    popd
  '';

  cargoHash = "sha256-r5FOl3Bp3GYhOhvWj/y6FXsuG2wvuFcMcYKBzVBVqiM=";

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
      openssl
      sqlite
    ]
    ++ lib.optionals stdenv.isDarwin [
      AppKit
      CoreAudio
      CoreGraphics
      Foundation
      IOKit
      MediaPlayer
      Security
    ]
    ++ lib.optionals stdenv.isLinux [
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
