{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pulldown-cmark";
  version = "0.13.4";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-XMKUFbPsYhYIxMxEvUJT38Jr03lzy9afRqe6tIj9lls=";
  };

  cargoHash = "sha256-JgGvRSUE6UXf0pSl6x6SC7gGgTEoq2E3t0tPrueuIEE=";

  meta = {
    description = "Pull parser for CommonMark written in Rust";
    homepage = "https://github.com/raphlinus/pulldown-cmark";
    license = with lib.licenses; mit;
    maintainers = with lib.maintainers; [ CobaltCause ];
    mainProgram = "pulldown-cmark";
  };
})
