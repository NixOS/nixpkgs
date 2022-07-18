{ lib
, stdenv
, fetchCrate
, rustPlatform
, pkg-config
, alsa-lib }:

rustPlatform.buildRustPackage rec {
  pname = "termusic";
  version = "0.6.17";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-diZl+izb55EFQaL6soLVNrFhoi7AOFkFnVcAU2XlI+c=";
  };

  cargoHash = "sha256-VW+tMnjuVnf/PsBAoMnOxbyNna1UpGB/5V52XSzBJr8=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsa-lib ];

  meta = with lib; {
    description = "Terminal Music Player TUI written in Rust";
    homepage = "https://github.com/tramhao/termusic";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ devhell ];
  };
}
