{ lib
, stdenv
, fetchCrate
, rustPlatform
, pkg-config
, alsa-lib }:

rustPlatform.buildRustPackage rec {
  pname = "termusic";
  version = "0.7.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-n5Z6LnZ0x+V46Exa9vSMrndZHperJlcXl1unfeTuo9M=";
  };

  cargoHash = "sha256-eIM0/SWLZVyVsHyQ4GzKSjVTvK7oActAiBEv56+JqK4=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsa-lib ];

  meta = with lib; {
    description = "Terminal Music Player TUI written in Rust";
    homepage = "https://github.com/tramhao/termusic";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ devhell ];
  };
}
