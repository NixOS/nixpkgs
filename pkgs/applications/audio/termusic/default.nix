{ lib
, stdenv
, fetchCrate
, rustPlatform
, pkg-config
, alsa-lib }:

rustPlatform.buildRustPackage rec {
  pname = "termusic";
  version = "0.7.5";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-/wpaxXY0hT7XX44cW1f3JuowE5u46/aLMC2VXgty/jE=";
  };

  cargoHash = "sha256-TznzZ1dcun57IQ8e2T2FOxSdyqxS6etnuvxOY8n1y14=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsa-lib ];

  meta = with lib; {
    description = "Terminal Music Player TUI written in Rust";
    homepage = "https://github.com/tramhao/termusic";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ devhell ];
  };
}
