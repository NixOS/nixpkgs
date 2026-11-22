{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdbook-katex";
  version = "0.10.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-gpzgY4c/hm2H3thY/kepqgzvXYM0ODzDQMR3Gor4fsE=";
  };

  cargoHash = "sha256-YqQ8Uai2mCG+1X/TmWJPszLYumOjF455Aa5WldgGXF0=";

  meta = {
    description = "Preprocessor for mdbook, rendering LaTeX equations to HTML at build time";
    mainProgram = "mdbook-katex";
    homepage = "https://github.com/lzanini/mdbook-katex";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      lovesegfault
      matthiasbeyer
    ];
  };
})
