{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  writableTmpDirAsHomeHook,
  writeText,

  fixup-yarn-lock,
  nodejs,
  yarn,

  # Custom application configuration placed to theme/config.theme.js file
  # For the list of available configuration options see
  # https://github.com/osm-search/nominatim-ui/blob/master/dist/config.defaults.js
  customConfig ? null,
}:

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

stdenv.mkDerivation (finalAttrs: {
  pname = "nominatim-ui";
  version = "3.7.1";

  src = fetchFromGitHub {
    owner = "osm-search";
    repo = "nominatim-ui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TliTWDKdIp7Z0uYw5P65i06NQAUNwNymUsSYrihVZFE=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-IqwsXEd9RSJhkA4BONTJT4xYMTyG9+zddIpD47v6AFc=";
  };

  nativeBuildInputs = [
    writableTmpDirAsHomeHook

    fixup-yarn-lock
    nodejs
    yarn
  ];

  configurePhase = ''
    runHook preConfigure

    yarn config --offline set yarn-offline-mirror $offlineCache
    fixup-yarn-lock yarn.lock

    yarn install --offline --frozen-lockfile --frozen-engines --ignore-scripts
    patchShebangs node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline build

    runHook postBuild
  '';

  preInstall = ''
    ln --symbolic ${configFile} dist/theme/config.theme.js
  '';

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
