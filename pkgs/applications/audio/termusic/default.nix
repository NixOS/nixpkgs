{ lib
, stdenv
, fetchCrate
, rustPlatform
, pkg-config
, alsa-lib }:

rustPlatform.buildRustPackage rec {
  pname = "termusic";
  version = "0.6.10";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-i+XxEPkLZK+JKDl88P8Nd7XBhsGhEzvUGovJtSWvRtg=";
  };

  cargoHash = "sha256-7nQzU1VvRDrtltVAXTX268vl9AbQhMOilPG4nNAJ+Xk=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsa-lib ];

  meta = with lib; {
    description = "Terminal Music Player TUI written in Rust";
    homepage = "https://github.com/tramhao/termusic";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ devhell ];
  };
}
