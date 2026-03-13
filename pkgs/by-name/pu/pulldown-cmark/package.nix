{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "pulldown-cmark";
  version = "0.13.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-iQjA2mt1l0mP8yevWwjrfN/u9FXBnIv+ObjMSOsqlhw=";
  };

  cargoHash = "sha256-D7ig9MofwFvurZDtpozn4xz63tCFQ2HrWcM/x1GzhqI=";

  meta = {
    description = "Pull parser for CommonMark written in Rust";
    homepage = "https://github.com/raphlinus/pulldown-cmark";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ CobaltCause ];
    mainProgram = "pulldown-cmark";
  };
}
