{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "deciduous";
  version = "0.13.7";

  src = fetchCrate {
    pname = "deciduous";
    version = finalAttrs.version;
    hash = "sha256-wx2i8+W55KGviVDvySvm6Eiv9Z83C9EcfmVV5HbTBWk=";
  };

  cargoHash = "sha256-5iaTC7Zd6L3BMB7McFuxfnPoppwtFYBAJyhMjQd8kGw=";

  meta = {
    description = "Decision graph tooling for AI-assisted development - track every choice, query your reasoning";
    mainProgram = "decidous";
    homepage = "https://notactuallytreyanastasio.github.io/deciduous/";
    changelog = "https://github.com/notactuallytreyanastasio/deciduous/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.viraptor ];
  };
})
