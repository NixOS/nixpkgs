{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "osmtogeojson";
  version = "3.0.0-beta.5";

  src = fetchFromGitHub {
    owner = "tyrasd";
    repo = pname;
    rev = version;
    hash = "sha256-T6d/KQQGoXHgV0iNhOms8d9zfjYMfnBNwPLShrEkHG4=";
  };

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  npmDepsHash = "sha256-stAVuyjuRQthQ3jQdekmZYjeau9l0GzEEMkV1q5fT2k=";
  dontNpmBuild = true;

  meta = with lib; {
    description = "Converts OSM data to GeoJSON";
    homepage = "https://tyrasd.github.io/osmtogeojson/";
    maintainers = with maintainers; [ thibautmarty ];
    license = licenses.mit;
    mainProgram = "osmtogeojson";
  };
}
