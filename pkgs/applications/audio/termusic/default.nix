{ lib
, stdenv
, fetchCrate
, rustPlatform
, pkg-config
, alsa-lib }:

rustPlatform.buildRustPackage rec {
  pname = "termusic";
  version = "0.7.7";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-ynSNgiy8TUxRBDAi4rSPd5ztSLMaaFg1yEMTD1TI3V4=";
  };

  cargoHash = "sha256-jD+oJw9xGY9ItYvoIUMwn8HrM72+02wOTeXEJjkZAfk=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsa-lib ];

  meta = with lib; {
    description = "Terminal Music Player TUI written in Rust";
    homepage = "https://github.com/tramhao/termusic";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ devhell ];
  };
}
