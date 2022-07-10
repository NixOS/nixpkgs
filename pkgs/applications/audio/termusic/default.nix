{ lib
, stdenv
, fetchCrate
, rustPlatform
, pkg-config
, alsa-lib }:

rustPlatform.buildRustPackage rec {
  pname = "termusic";
  version = "0.6.16";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-2xPm4DahTv3+T92qMYuistfPTlZaJUushP0yrgHYqco=";
  };

  cargoHash = "sha256-oPRW1x/hXhT8LBW3Z3jMBoal5zC6jKKOTo/RrDwgeJU=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsa-lib ];

  meta = with lib; {
    description = "Terminal Music Player TUI written in Rust";
    homepage = "https://github.com/tramhao/termusic";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ devhell ];
  };
}
