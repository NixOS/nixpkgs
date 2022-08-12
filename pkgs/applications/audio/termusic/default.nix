{ lib
, stdenv
, fetchCrate
, rustPlatform
, pkg-config
, alsa-lib }:

rustPlatform.buildRustPackage rec {
  pname = "termusic";
  version = "0.7.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-4o36h/x4+h2H4xpgPfOgIza6zNANyhmSM3Cm1XwWb7w=";
  };

  cargoHash = "sha256-WHxrMD6W7UyJg8HhjxWlm9KQ5SKsM6fLdvhDzBb16pI=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsa-lib ];

  meta = with lib; {
    description = "Terminal Music Player TUI written in Rust";
    homepage = "https://github.com/tramhao/termusic";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ devhell ];
  };
}
