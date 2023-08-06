{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, protobuf
, dbus
, openssl
, pkg-config
, alsa-lib
, darwin
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

  buildInputs = lib.optionals stdenv.isLinux [
    alsa-lib
    dbus
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AudioUnit
  ];

  meta = with lib; {
    description = "Terminal Music Player TUI written in Rust";
    homepage = "https://github.com/tramhao/termusic";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ devhell ];
  };
}
