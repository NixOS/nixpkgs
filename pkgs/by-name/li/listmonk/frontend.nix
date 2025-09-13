{
  stdenv,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  meta,
  version,
  src,
  yarnHash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "listmonk-frontend";
  inherit version;

  src = "${src}/frontend";

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/frontend/yarn.lock";
    hash = yarnHash;
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
  ];

  installPhase = ''
    mkdir $out
    cp -R dist/* $out
  '';

  inherit meta;
})
