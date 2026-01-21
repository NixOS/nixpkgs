{
  stdenv,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  meta,
  version,
  src,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "listmonk-frontend";
  inherit version;

  src = "${src}/frontend";

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/frontend/yarn.lock";
    hash = "sha256-FVnODCSLJYXb9KO2nNV52Z6hza+1619KjXNtXqmZv8o=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
  ];

  installPhase = ''
    mkdir -p $out/admin
    cp -R dist/* $out/admin
    cp node_modules/altcha/dist/altcha.umd.cjs $out/altcha.umd.js
  '';

  inherit meta;
})
