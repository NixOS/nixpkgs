{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarn,
  fixup-yarn-lock,
  nodejs,
  olm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hydrogen-web";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "hydrogen-web";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pXrmWPp4/MYIS1FHEGzAxGbh4OnTaiPudg+NauvA6Vc=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-j+BwlmL0ncaccy9qQbzb9GpDRC4KB9MwOR2ISx+vbLE=";
  };

  nativeBuildInputs = [
    yarn
    fixup-yarn-lock
    nodejs
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$PWD/tmp
    mkdir -p $HOME

    fixup-yarn-lock yarn.lock
    yarn config --offline set yarn-offline-mirror $offlineCache
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn build --offline

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -R target $out

    runHook postInstall
  '';

  meta = {
    description = "Lightweight matrix client with legacy and mobile browser support";
    homepage = "https://github.com/element-hq/hydrogen-web";
    teams = [ lib.teams.matrix ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    inherit (olm.meta) knownVulnerabilities;
  };
})
