{ stdenv
, fetchYarnDeps
, yarnConfigHook
, yarnBuildHook
, nodejs
, meta
, version
, src
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "listmonk-frontend";
  inherit version;

  src = "${src}/frontend";

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/frontend/yarn.lock";
    hash = "sha256-TdrglyRtb2Q8SFtoiCoDj/zBV2+7DwzIm/Fzlt0ZvSo=";
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
