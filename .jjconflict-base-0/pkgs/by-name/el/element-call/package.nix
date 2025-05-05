{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  git,
  yarn-berry,
  yarnConfigHook,
  nodejs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "element-call";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "element-call";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hKlzp6dDYRp1fM6soho84nP0phkQkaGJEGUf0MqzQGc=";
  };

  matrixJsSdkRevision = "19b1b901f575755d29d1fe03ca48cbf7c1cae05c";
  matrixJsSdkOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.offlineCache}/checkouts/${finalAttrs.matrixJsSdkRevision}/yarn.lock";
    hash = "sha256-pi2MW+58DCkHJDOxMWeXzF+v+5JhJFGQcUgsRsYjNvw=";
  };

  dontYarnInstallDeps = true;
  preConfigure = ''
    cp -r $offlineCache writable
    chmod u+w -R writable
    pushd writable/checkouts/${finalAttrs.matrixJsSdkRevision}/
    mkdir -p .git/{refs,objects}
    echo ${finalAttrs.matrixJsSdkRevision} > .git/HEAD
    SKIP_YARN_COREPACK_CHECK=1 offlineCache=$matrixJsSdkOfflineCache yarnConfigHook
    popd
    offlineCache=writable
  '';

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-Pv9ioa6F5gNx+8oMJvvRI/LTJGJ4ALrIQFvoH++szuo=";
  };

  nativeBuildInputs = [
    git
    yarn-berry.yarnBerryConfigHook
    yarnConfigHook
    nodejs
  ];

  buildPhase = ''
    runHook preBuild
    ${lib.getExe yarn-berry} build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r dist/* $out

    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://github.com/element-hq/element-call/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/element-hq/element-call";
    description = "Group calls powered by Matrix";
    license = licenses.asl20;
    maintainers = with maintainers; [ kilimnik ];
  };
})
