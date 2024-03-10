{ mkYarnPackage
, fetchYarnDeps
, meta
, version
, src
}:

mkYarnPackage {
  pname = "listmonk-frontend";
  inherit version;

  src = "${src}/frontend";
  packageJSON = ./package.json;

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/frontend/yarn.lock";
    hash = "sha256-TdrglyRtb2Q8SFtoiCoDj/zBV2+7DwzIm/Fzlt0ZvSo=";
  };

  configurePhase = ''
    ln -s $node_modules node_modules
  '';

  buildPhase = ''
    yarn --offline build
  '';

  installPhase = ''
    mkdir $out
    cp -R dist/* $out
  '';

  doDist = false;


  inherit meta;
}
