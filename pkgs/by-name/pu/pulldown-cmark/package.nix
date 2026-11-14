{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pulldown-cmark";
  version = "0.13.6";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-PMvBSB/pciexKWbZAZt/Nu7mBOhuPdNeyDTp1OEc3+E=";
  };

  cargoHash = "sha256-WqwSTZWKwIqu1HSlplG1rMe5oup+ZkENmYhluibwujs=";

  meta = {
    description = "Pull parser for CommonMark written in Rust";
    homepage = "https://github.com/raphlinus/pulldown-cmark";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ CobaltCause ];
    mainProgram = "pulldown-cmark";
  };
})
