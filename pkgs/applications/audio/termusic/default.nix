<<<<<<< HEAD
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
=======
{ lib
, stdenv
, rustPlatform
, fetchCrate
, fetchpatch
, pkg-config
, alsa-lib
, darwin
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "termusic";
<<<<<<< HEAD
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
=======
  version = "0.7.10";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-m0hi5u4BcRcEDEpg1BoWXc25dfhD6+OJtqSZfSdV0HM=";
  };

  cargoHash = "sha256-A83gLsaPm6t4nm7DJfcp9z1huDU/Sfy9gunP8pzBiCA=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    alsa-lib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AudioUnit
  ];

  meta = with lib; {
    description = "Terminal Music Player TUI written in Rust";
    homepage = "https://github.com/tramhao/termusic";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ devhell ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
