{
  stdenv,
  fetchYarnDeps,
  src,
  version,
  nodejs,
  eintopf,
  yarnConfigHook,
  yarnBuildHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eintopf";
  inherit version src;

  sourceRoot = "${finalAttrs.src.name}/backstage";

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/backstage/yarn.lock";
    hash = "sha256-3TPBrQxvTfmBfhAavHy8eDcZwRZMwu0dCovnE1fcuTE=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    # Needed for executing package.json scripts
    nodejs
  ];

  installPhase = ''
    runHook preInstall

    yarn --offline --production install

    mkdir -p "$out"
    cp -r . $out/

    runHook postInstall
  '';

  meta = {
    inherit (eintopf.meta)
      homepage
      description
      license
      maintainers
      ;
  };
})
