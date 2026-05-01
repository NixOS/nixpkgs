{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pulldown-cmark";
  version = "0.13.3";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-TeNF8Fgfo9m/TEAXBogzioSEVkY5lKOBm33HELk+WZE=";
  };

  cargoHash = "sha256-i0mQvxtDKrU3hXe5LGMygELBVnMhtRytSPDA9u+49mI=";

  meta = {
    description = "Pull parser for CommonMark written in Rust";
    homepage = "https://github.com/raphlinus/pulldown-cmark";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ CobaltCause ];
    mainProgram = "pulldown-cmark";
  };
})
