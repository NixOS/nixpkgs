{ lib
, stdenv
, fetchCrate
, rustPlatform
, pkg-config
, alsa-lib }:

rustPlatform.buildRustPackage rec {
  pname = "termusic";
  version = "0.7.3";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-5I9Fu+A5IBfaxaPcYKTzWq3/8ts0BPSOOVeU6D61dbc=";
  };

  cargoHash = "sha256-R/hElL0MjeBqboJTQkIREPOh+/YbdKtUAzqPD6BpSPs=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsa-lib ];

  meta = with lib; {
    description = "Terminal Music Player TUI written in Rust";
    homepage = "https://github.com/tramhao/termusic";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ devhell ];
  };
}
