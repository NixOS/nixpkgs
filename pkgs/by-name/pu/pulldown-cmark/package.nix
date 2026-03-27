{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pulldown-cmark";
  version = "0.13.2";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-+nwk1pfYmeiJu8dqin61i384NFMvaHeVv8r79gVAOoU=";
  };

  cargoHash = "sha256-rap/rnYSlFW9QYP3ToLuPDs8KIf3u6i6RMSNtmFfEus=";

  meta = {
    description = "Pull parser for CommonMark written in Rust";
    homepage = "https://github.com/raphlinus/pulldown-cmark";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ CobaltCause ];
    mainProgram = "pulldown-cmark";
  };
})
