{
  lib,
  fetchFromGitHub,
  fetchYarnDeps,
  mkYarnPackage,
  writeText,

  # Custom application configuration placed to theme/config.theme.js file
  # For the list of available configuration options see
  # https://github.com/osm-search/nominatim-ui/blob/master/dist/config.defaults.js
  customConfig ? null,
}:

# Notes for the upgrade:
# * Download the tarball of the new version to use.
# * Replace new `package.json` here.
# * Update `version`+`hash` and rebuild.

let
  configFile =
    if customConfig != null then
      writeText "config.theme.js" customConfig
    else
      writeText "config.theme.js" ''
        // Default configuration
        Nominatim_Config.Nominatim_API_Endpoint='https://127.0.0.1/';
      '';
in
mkYarnPackage rec {
  pname = "nominatim-ui";
  version = "3.7.1";

  src = fetchFromGitHub {
    owner = "osm-search";
    repo = "nominatim-ui";
    tag = "v${version}";
    hash = "sha256-TliTWDKdIp7Z0uYw5P65i06NQAUNwNymUsSYrihVZFE=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-IqwsXEd9RSJhkA4BONTJT4xYMTyG9+zddIpD47v6AFc=";
  };

  packageJSON = ./package.json;

  buildPhase = ''
    runHook preBuild

    yarn --offline build

    runHook postBuild
  '';

  preInstall = ''
    ln --symbolic ${configFile} deps/nominatim-ui/dist/theme/config.theme.js
  '';

  installPhase = ''
    runHook preInstall

    cp --archive deps/nominatim-ui/dist $out

    runHook postInstall
  '';

  doDist = false;

  meta = {
    description = "Debugging user interface for Nominatim geocoder";
    homepage = "https://github.com/osm-search/nominatim-ui";
    license = lib.licenses.gpl2;
    teams = with lib.teams; [
      geospatial
      ngi
    ];
    changelog = "https://github.com/osm-search/nominatim-ui/releases/tag/v${version}";
  };
}
