{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarn,
  fixup-yarn-lock,
  nodejs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hydrogen-web";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "vector-im";
    repo = "hydrogen-web";
    rev = "v${finalAttrs.version}";
    hash = "sha256-u8Yex3r7EZH+JztQHJbfncYeyyl6hgb1ZNFIg//wcb0=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-N9lUAhfYLlEAIaWSNS3Ecq+aBTz+f7Z22Sclwj9rp6w=";
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
    homepage = "https://github.com/vector-im/hydrogen-web";
    maintainers = lib.teams.matrix.members;
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
})
