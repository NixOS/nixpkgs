{ lib
, stdenv
, fetchCrate
, rustPlatform
, pkg-config
, alsa-lib }:

rustPlatform.buildRustPackage rec {
  pname = "termusic";
  version = "0.6.15";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-e4hCo5a54EPp6/sd1/ivwHePu+e6MqbA9tvPWf41EhQ=";
  };

  cargoHash = "sha256-kQjLmASJpo7+LT73vVjbPWhNUGJ1HI6S/8W6gJskJXE=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsa-lib ];

  meta = with lib; {
    description = "Terminal Music Player TUI written in Rust";
    homepage = "https://github.com/tramhao/termusic";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ devhell ];
  };
}
