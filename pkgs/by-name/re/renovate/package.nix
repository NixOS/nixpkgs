{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  nodejs_26,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  python3,
  testers,
  xcbuild,
  nixosTests,
  nix-update-script,
  yq-go,
  cctools,
}:

let
  nodejs = nodejs_26;
  pnpm = pnpm_11;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "renovate";
  version = "44.247.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "renovatebot";
    repo = "renovate";
    tag = finalAttrs.version;
    hash = "sha256-P0tlgSjt3OY6UymMoPobz1NAUmh5gLm2NqpL9JG91fM=";
  };

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail "0.0.0-semantic-release" "${finalAttrs.version}"
  '';

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpmConfigHook
    pnpm
    python3
    yq-go
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    xcbuild
    cctools # contains libtool, required by better-sqlite3
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 5;
    hash = "sha256-KM5vpUTleTwzsIgmHp3qRNy4FBa0INURWXAlvDq33KI=";
  };

  env.COREPACK_ENABLE_STRICT = 0;

  buildPhase = ''
    runHook preBuild

    # relax nodejs version
    yq '.engines.node = "${nodejs.version}"' -i package.json
  ''
  # pnpm install gets run with --ignore-scripts so we need to manually build native dependencies (e.g. re2)
  # Keep https://github.com/renovatebot/renovate/blob/main/pnpm-workspace.yaml#L9 in mind when updating,
  # new native dependencies could bloat up binary size.
  + ''
    pnpm rebuild
    pnpm build
    pnpm prune --prod --ignore-scripts

    # re2 only needs its compiled addon at runtime, the rest of its build output
    # and node-gyp reference python3, pnpm and nodejs-slim
    re2=$(echo node_modules/.pnpm/re2@*/node_modules/re2)
    find $re2/build -mindepth 1 ! -path $re2/build/Release ! -path $re2/build/Release/re2.node -delete
    rm -r $re2/vendor $re2/../node-gyp node_modules/.pnpm/{node-gyp@*,node_modules/node-gyp}

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

  disallowedRequisites = [
    python3
    pnpm
    pnpm.nodejs-slim
  ];

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
