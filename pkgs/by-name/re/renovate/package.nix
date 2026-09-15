{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  nodejs_24,
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
  nodejs = nodejs_24;
  pnpm = pnpm_11;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "renovate";
  version = "44.52.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "renovatebot";
    repo = "renovate";
    tag = finalAttrs.version;
    hash = "sha256-qSec1SR+FN2SY+dz25J3NFeiUwmzex9cvEKb0XJFLM0=";
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
    fetcherVersion = 4;
    hash = "sha256-sQ4895f7aeCZ+/ZChEwJoZNtZGCyRVGEONuGbkDpPtY=";
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
    rm -rf node_modules/.pnpm/re2*/node_modules/re2/build/Release/{obj.target,.deps} \
      node_modules/.pnpm/re2*/node_modules/re2/vendor

    pnpm build
    pnpm prune --prod --ignore-scripts

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
