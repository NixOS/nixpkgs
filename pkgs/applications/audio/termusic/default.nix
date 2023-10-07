{
  alsa-lib
, AppKit
, CoreAudio
, CoreGraphics
, dbus
, Foundation
, fetchFromGitHub
, glib
, gst_all_1
, IOKit
, lib
, MediaPlayer
, openssl
, pkg-config
, protobuf
, rustPlatform
, Security
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
    AppKit
    CoreAudio
    CoreGraphics
    Foundation
    IOKit
    MediaPlayer
    Security
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
