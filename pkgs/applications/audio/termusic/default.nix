{
  alsa-lib
, darwin
, dbus
, fetchFromGitHub
, glib
, gst_all_1
, lib
, openssl
, pkg-config
, protobuf
, rustPlatform
, sqlite
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "termusic";
  version = "0.7.11";

  src = fetchFromGitHub {
    owner = "tramhao";
    repo = "termusic";
    rev = "v${version}";
    hash = "sha256-ykOBXM/WF+zasAt+6mgY2aSFCpGaYcqk+YI7YLM3MWs=";
  };

  cargoHash = "sha256-BrOpU0RFdlRXQIMjfHfs/XYIdBCYKFSA+5by/rGzC8Y=";

  nativeBuildInputs = [
    pkg-config
    protobuf
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    dbus
    glib
    gst_all_1.gstreamer
    openssl
    sqlite
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.CoreAudio
    darwin.apple_sdk.frameworks.CoreGraphics
    darwin.apple_sdk.frameworks.Foundation
    darwin.apple_sdk.frameworks.IOKit
    darwin.apple_sdk.frameworks.MediaPlayer
    darwin.apple_sdk.frameworks.Security
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
  ];

  meta = {
    description = "Terminal Music Player TUI written in Rust";
    homepage = "https://github.com/tramhao/termusic";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ devhell ];
  };
}
