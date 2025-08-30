{
  stdenv,
  fetchYarnDeps,
  src,
  version,
  nodejs,
  lauti,
  yarnConfigHook,
  yarnBuildHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lauti";
  inherit version src;

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    # Needed for executing package.json scripts
    nodejs
  ];

  preBuild = ''
    cd backstage
  '';

  installPhase = ''
    runHook preInstall

    yarn --offline --production install

    mkdir -p "$out"
    cp -r . $out/

    runHook postInstall
  '';

  meta = {
    inherit (lauti.meta)
      homepage
      description
      license
      maintainers
      ;
  };
})
