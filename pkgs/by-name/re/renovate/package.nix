{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  nodejs_24,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  python3,
  testers,
  xcbuild,
  nixosTests,
  nix-update-script,
  yq-go,
}:
let
  nodejs = nodejs_24;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "renovate";
  version = "43.4.0";

  src = fetchFromGitHub {
    owner = "renovatebot";
    repo = "renovate";
    tag = finalAttrs.version;
    hash = "sha256-REJHbpVKvyD7dpp1smfW+uLwKFcoe8nOJs2KdYnCbeg=";
  };

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail "0.0.0-semantic-release" "${finalAttrs.version}"
  '';

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpmConfigHook
    pnpm_10
    python3
    yq-go
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin xcbuild;

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 2;
    hash = "sha256-rzFbz5PONCXrqXN2WPxlP7O2pOwdFHvUmjIrIRXXiUQ=";
  };

  env.COREPACK_ENABLE_STRICT = 0;

  buildPhase = ''
    runHook preBuild

    # relax nodejs version
    yq '.engines.node = "${nodejs.version}"' -i package.json

    pnpm build
    find -name 'node_modules' -type d -exec rm -rf {} \; || true
    pnpm install --offline --prod --ignore-scripts
  ''
  # The optional dependencies re2 and better-sqlite3 are not built by pnpm and need to be built manually.
  # If re2 is not built, you will get an annoying warning when you run renovate.
  # better-sqlite3 is required.
  + ''
    pushd node_modules/.pnpm/re2*/node_modules/re2

    mkdir -p $HOME/.node-gyp/${nodejs.version}
    echo 9 > $HOME/.node-gyp/${nodejs.version}/installVersion
    ln -sfv ${nodejs}/include $HOME/.node-gyp/${nodejs.version}
    export npm_config_nodedir=${nodejs}
    npm run rebuild
    rm -rf build/Release/{obj.target,.deps} vendor

    popd

    pushd node_modules/.pnpm/better-sqlite3*/node_modules/better-sqlite3
    npm run build-release
    rm -rf build/Release/{obj.target,sqlite3.a,.deps} deps

    popd

    runHook postBuild
  '';

  # TODO: replace with `pnpm deploy`
  # now it fails to build with ERR_PNPM_NO_OFFLINE_META
  # see https://github.com/pnpm/pnpm/issues/5315
  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/node_modules/renovate}
    cp -r dist node_modules package.json renovate-schema.json $out/lib/node_modules/renovate

    makeWrapper "${lib.getExe nodejs}" "$out/bin/renovate" \
      --add-flags "$out/lib/node_modules/renovate/dist/renovate.js"
    makeWrapper "${lib.getExe nodejs}" "$out/bin/renovate-config-validator" \
      --add-flags "$out/lib/node_modules/renovate/dist/config-validator.js"

    runHook postInstall
  '';

  passthru = {
    tests = {
      version = testers.testVersion { package = finalAttrs.finalPackage; };
      vm-test = nixosTests.renovate;
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^(\\d+\\.\\d+\\.\\d+)$"
      ];
    };
  };

  meta = {
    description = "Cross-platform Dependency Automation by Mend.io";
    homepage = "https://github.com/renovatebot/renovate";
    changelog = "https://github.com/renovatebot/renovate/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      marie
      natsukium
    ];
    mainProgram = "renovate";
    platforms = nodejs.meta.platforms;
  };
})
