{ lib
, stdenv
, fetchCrate
, rustPlatform
, pkg-config
, alsa-lib }:

rustPlatform.buildRustPackage rec {
  pname = "termusic";
  version = "0.7.9";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-ytAKINcZwLyHWbzShxfxRKx4BepM0G2BYdLgwR48g7w=";
  };

  cargoHash = "sha256-yxFF5Yqj+xTB3FAJUtgcIeAEHR44JA1xONxGFdG0yS0=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsa-lib ];

  meta = with lib; {
    description = "Terminal Music Player TUI written in Rust";
    homepage = "https://github.com/tramhao/termusic";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ devhell ];
  };
}
