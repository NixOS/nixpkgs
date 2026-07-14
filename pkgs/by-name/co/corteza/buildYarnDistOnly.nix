{
  pname,
  version,
  src,
  sourceDir,
  yarnLock ? null,
  hash,
  extraFiles ? "",
  meta,

  fetchYarnDeps,
  lib,
  nodejs_22,
  stdenvNoCC,
  yarnBuildHook,
  yarnConfigHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  inherit
    pname
    version
    src
    meta
    ;
  sourceRoot = "${finalAttrs.src.name}/${sourceDir}";

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = if yarnLock != null then yarnLock else "${finalAttrs.src}/${sourceDir}/yarn.lock";
    inherit hash;
  };

  postPatch = lib.optionalString (yarnLock != null) ''
    cp ${yarnLock} ./yarn.lock
  '';

  nativeBuildInputs = [
    nodejs_22
    yarnBuildHook
    yarnConfigHook
  ];

  BUILD_VERSION = finalAttrs.version;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r dist/* ${extraFiles} $out

    runHook postInstall
  '';
})
