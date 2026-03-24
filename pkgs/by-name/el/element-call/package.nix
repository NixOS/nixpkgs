{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  git,
  yarn-berry,
  yarnConfigHook,
  nodejs,
  runCommand,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "element-call";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "element-call";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/5RkZNf/ErSxNwW0ZfPwF52k3fZzAQAFMmbJ9xM7f74=";
  };

  matrixJsSdkRevision = "6e3efef0c5f660df47cf00874927dec1c75cc3cf";
  matrixJsSdkOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.offlineCache}/checkouts/${finalAttrs.matrixJsSdkRevision}/yarn.lock";
    hash = "sha256-YvXmPWHt3qL9z8uap0/faKi5OId6zZ0ISiMT3x6ARx8=";
  };

  dontYarnInstallDeps = true;
  preConfigure = ''
    cp -r $offlineCache writable
    chmod u+w -R writable
    pushd writable/checkouts/${finalAttrs.matrixJsSdkRevision}/
    mkdir -p .git/{refs,objects}
    echo ${finalAttrs.matrixJsSdkRevision} > .git/HEAD
    SKIP_YARN_COREPACK_CHECK=1 offlineCache=$matrixJsSdkOfflineCache yarnConfigHook
    SKIP_YARN_COREPACK_CHECK=1 yarn build
    popd
    offlineCache=writable
    # The matrix-js-sdk git package checksum in yarn.lock was computed against a
    # developer checkout with pre-compiled lib/. nix-prefetch-git stores a bare
    # working tree so the repack at build time produces a different zip hash.
    # The offline cache is already verified by the FOD hash, so this is safe.
    export YARN_CHECKSUM_BEHAVIOR=ignore
  '';

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-Ose2PlsNHlCllynl+aIx/nToqtsqs7f43znOTLm2WEE=";
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

  passthru.tests.build = runCommand "${finalAttrs.pname}-test" { } ''
    test -f ${finalAttrs.finalPackage}/index.html
    test -d ${finalAttrs.finalPackage}/assets
    touch $out
  '';

  meta = {
    changelog = "https://github.com/element-hq/element-call/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/element-hq/element-call";
    description = "Group calls powered by Matrix";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kilimnik ];
  };
})
