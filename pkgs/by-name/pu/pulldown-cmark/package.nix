{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "pulldown-cmark";
  version = "0.12.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-dsSt0JC3e1IItyY16tosxD83XUdttHVIT40QsW9iUFU=";
  };

  cargoHash = "sha256-siYwv14AzoQnub+Xcb3UCdEnCIOYremqNve5xyMhixc=";

  meta = {
    description = "Pull parser for CommonMark written in Rust";
    homepage = "https://github.com/raphlinus/pulldown-cmark";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ CobaltCause ];
    mainProgram = "pulldown-cmark";
  };
}
