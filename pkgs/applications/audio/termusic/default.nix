{ lib
, stdenv
, fetchCrate
, rustPlatform
, pkg-config
, alsa-lib }:

rustPlatform.buildRustPackage rec {
  pname = "termusic";
  version = "0.7.8";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-1RlG1/2+NuMO9zqFHQaEkEX1YrYYMjnaNprjdl1ZnHQ=";
  };

  cargoHash = "sha256-SYk2SiFbp40/6Z0aBoX4MPnPLHjEfsJKCW4cErm0D78=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsa-lib ];

  meta = with lib; {
    description = "Terminal Music Player TUI written in Rust";
    homepage = "https://github.com/tramhao/termusic";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ devhell ];
  };
}
