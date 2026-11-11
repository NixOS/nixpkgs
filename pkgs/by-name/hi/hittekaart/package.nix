{
  lib,
  rustPlatform,
  fetchFromCodeberg,
  python3,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hittekaart";
  version = "0.2.1";

  src = fetchFromCodeberg {
    owner = "dunj3";
    repo = "hittekaart";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MMHtcO55d0IRwJ1VcHj1WVPDT8N+gTrdq05hVmHUIIw=";
  };

  cargoHash = "sha256-Dz5EY0EW7WUpB7gsGWRHyXjDLHIdLbqHBBwemKGOWF0=";

  nativeBuildInputs = [ python3 ];

  buildInputs = [ sqlite ];

  meta = {
    description = "Renders heatmaps by reading GPX files and generating OSM overlay tiles";
    homepage = "https://codeberg.org/dunj3/hittekaart";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.geospatial ];
    mainProgram = "hittekaart";
  };
})
