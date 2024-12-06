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
  packageJSON = ./package.json;

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/frontend/yarn.lock";
    hash = "sha256-2STFJtlneyR6QBsy/RVIINV/0NMggnfZwyz1pki8iPk=";
  };

  configurePhase = ''
    ln -s $node_modules node_modules
  '';

  buildPhase = ''
    yarn --offline build
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r dist/* $out

    runHook postInstall
  '';

  doDist = false;


  inherit meta;
}
