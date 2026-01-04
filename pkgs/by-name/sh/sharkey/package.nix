{
  stdenv,
  lib,
  fetchFromGitLab,
  nixosTests,
  bash,
  cairo,
  cctools,
  ffmpeg-headless,
  jemalloc,
  makeWrapper,
  nix-update-script,
  nodejs_22,
  pango,
  pixman,
  pkg-config,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  python3,
  vips,
  xcbuild,
}:

let
  pnpm = pnpm_10.override { nodejs = nodejs_22; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sharkey";
  version = "2025.10.2";

  src = fetchFromGitLab {
    domain = "activitypub.software";
    owner = "TransFem-org";
    repo = "Sharkey";
    tag = finalAttrs.version;
    hash = "sha256-JBcWcvhShsZMeilb40163N9eKl25FUBee//q/HNbVZA=";
    fetchSubmodules = true;
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm;
    fetcherVersion = 3;
    hash = "sha256-L1nqjdemFGqhS+qm8iSQZI5T6QtK4RyGm9IHDNd7rbo=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs_22
    pkg-config
    pnpmConfigHook
    pnpm
    python3
  ]
  ++ (lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
    xcbuild
  ]);

  buildInputs = [
    cairo
    pango
    pixman
    vips
  ];

  buildPhase = ''
    runHook preBuild

    # pnpm.fetchDeps doesn't run build scripts, so we need to run postinstall for this package otherwise the frontend
    # build fails
    pushd node_modules/.pnpm/node_modules/v-code-diff
    pnpm postinstall
    popd

    # rebuild some node modules that have native dependencies
    export npm_config_nodedir=${nodejs_22}

    pushd node_modules/.pnpm/node_modules/re2
    pnpm rebuild
    popd

    pushd node_modules/.pnpm/node_modules/sharp
    pnpm run install
    popd

    pushd node_modules/.pnpm/node_modules/canvas
    NIX_CFLAGS_COMPILE="-include cstdint $NIX_CFLAGS_COMPILE"
    pnpm run install
    popd

    pnpm build
    # FIXME: pruning does produce missing symlinks in fixupPhase at the moment
    # CI=true pnpm prune --prod --ignore-scripts

    runHook postBuild
  '';

  installPhase =
    let
      binPath = lib.makeBinPath [
        bash
        nodejs_22
        pnpm
      ];
      libPath = lib.makeLibraryPath [
        ffmpeg-headless
        jemalloc
        stdenv.cc.cc
      ];
    in
    ''
      runHook preInstall

      # adapted from repo dockerfile
      # https://activitypub.software/TransFem-org/Sharkey/-/blob/develop/Dockerfile?ref_type=heads
      mkdir -p $out/sharkey
      cp -r built fluent-emojis node_modules package.json pnpm-workspace.yaml $out/sharkey/

      mkdir -p $out/sharkey/packages/backend
      cp -r packages/backend/{assets,built,migration,node_modules,ormconfig.js,package.json} $out/sharkey/packages/backend/
      mkdir -p $out/sharkey/packages/backend/scripts
      cp -r packages/backend/scripts/check_connect.js $out/sharkey/packages/backend/scripts/

      mkdir -p $out/sharkey/packages/misskey-{bubble-game,js,reversi}
      cp -r packages/misskey-bubble-game/{built,node_modules,package.json} $out/sharkey/packages/misskey-bubble-game/
      cp -r packages/misskey-js/{built,node_modules,package.json} $out/sharkey/packages/misskey-js/
      cp -r packages/misskey-reversi/{built,node_modules,package.json} $out/sharkey/packages/misskey-reversi/

      mkdir -p $out/sharkey/packages/frontend{,-embed}
      cp -r packages/frontend/assets $out/sharkey/packages/frontend/
      cp -r packages/frontend-embed/assets $out/sharkey/packages/frontend-embed/

      # create a wrapper script for running sharkey commands (ie. alias for pnpm run)
      makeWrapper ${lib.getExe pnpm} $out/bin/sharkey \
        --chdir $out/sharkey \
        --add-flags run \
        --set-default NODE_ENV production \
        --prefix PATH : ${binPath} \
        --prefix LD_LIBRARY_PATH : ${libPath}

      runHook postInstall
    '';

  fixupPhase = ''
    runHook preFixup

    # cleanup dangling symlinks in node_modules, referencing workspace packages we don't include in the final output
    rm -r $out/sharkey/node_modules/.pnpm/node_modules/{sw,misskey-js-type-generator,frontend-shared,@jest,@types,@storybook,@vitest,@vue,@microsoft,frontend-builder,icons-subsetter}

    # remove packageManager line from package.json; tries to download a different pnpm version into $HOME otherwise
    sed -i -e '9d' $out/sharkey/package.json

    runHook postFixup
  '';

  passthru.tests.sharkey = nixosTests.sharkey;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Sharkish microblogging platform";
    homepage = "https://joinsharkey.org";
    changelog = "https://activitypub.software/TransFem-org/Sharkey/-/releases/${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "sharkey";
    maintainers = with lib.maintainers; [
      tmarkus
    ];
  };
})
