{
  lib,
  rustPlatform,
  fetchFromGitea,
  python3,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hittekaart";
  version = "0.1.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dunj3";
    repo = "hittekaart";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bog00/pkpTaUtLDfuR9d8yEhDt9mn9YDyF17ojZMM38=";
  };

  cargoHash = "sha256-Izcgxkl7QdNWYRrz9+nKMlCkEDtqiZTIAnJO/b7ZJKs=";

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
