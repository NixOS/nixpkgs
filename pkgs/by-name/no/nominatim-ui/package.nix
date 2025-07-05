{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nominatim-ui";
  version = "3.7.1";

  src = fetchFromGitHub {
    owner = "osm-search";
    repo = "nominatim-ui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TliTWDKdIp7Z0uYw5P65i06NQAUNwNymUsSYrihVZFE=";
  };

  installPhase = ''
    runHook preInstall

    cp --archive dist $out

    runHook postInstall
  '';

  meta = {
    description = "Debugging user interface for Nominatim geocoder";
    homepage = "https://github.com/osm-search/nominatim-ui";
    license = lib.licenses.gpl2;
    teams = with lib.teams; [
      geospatial
      ngi
    ];
    changelog = "https://github.com/osm-search/nominatim-ui/releases/tag/v${finalAttrs.version}";
  };
})
