{
  src,
  version,
  stdenv,
  yarnConfigHook,
  yarnBuildHook,
  nodejs-slim,
  fetchYarnDeps,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gotify-ui";
  inherit version;

  src = src + "/ui";

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-nU1K43ucv2DnDcIDee6I2t8fgz86NSyNvth2znlclsM=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs-slim
  ];

  env.NODE_OPTIONS = "--openssl-legacy-provider";

  installPhase = ''
    runHook preInstall

    mv build $out

    runHook postInstall
  '';
})
