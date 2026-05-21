{
  lib,
  rustPlatform,
  fetchFromGitea,
  python3,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hittekaart";
  version = "0.2.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dunj3";
    repo = "hittekaart";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Pp4biN20NWrTB11Bi14INl9g5VPPP79j9tbgXUe40qQ=";
  };

  cargoHash = "sha256-bo8PnAShrQJ9qPYk/yEhD8E0DZH2uJ427w0Wr34Xz/U=";

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
