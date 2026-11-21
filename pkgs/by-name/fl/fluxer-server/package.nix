{
  cacert,
  fetchFromGitHub,
  rustPlatform,
  fetchCrate,
  buildWasmBindgenCli,
  lib,
  tailwindcss_4,
  pkg-config,
  vips,
  libheif,
  nasm,
  yasm,
  jemalloc,
  zlib,
  ffmpeg-headless,
  lcms2,
  libwebp,
  libyuv,
  libde265,
  dav1d,
  libaom,
  zstd,
  coreutils,
  gawk,
  git,
  bash,
  nodejs_26,
  pnpm_11,
  pnpmConfigHook,
  beamMinimal28Packages,
  rustc,
  cargo,
  clang,
  lld,
  brotli,
  makeWrapper,
  runCommand,
  fetchPnpmDeps,
  fluxerHashes ? lib.importJSON ./pin.json,
}:
let
  # build tools
  nodejs = nodejs_26;
  pnpm = pnpm_11.override { nodejs-slim = nodejs; };
  beamPackages = beamMinimal28Packages;
  zstdStatic = zstd.override { enableStatic = true; };
  wasm-bindgen-cli = buildWasmBindgenCli rec {
    src = fetchCrate {
      pname = "wasm-bindgen-cli";
      version = "0.2.128";
      hash = "sha256-a7lcXJnnZkYReja+iUO7NqqrWyv3toxnUgQb8s4IS5s=";
    };

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit src;
      inherit (src) pname version;
      hash = "sha256-R1Tas33Ursy8kqsxguAkG0ZhNed2n5uFTAhw1l2qlLY=";
    };
  };

  # cargo deps
  copyCargoDeps =
    deps:
    ''cp -r --no-clobber --no-preserve=mode "${deps}/source-registry-0/." "$out/source-registry-0/"'';
  mergeCargoDeps =
    # merge several `fetchCargoVendor` derivations into one store
    # the primary (`root-dep`) derivation also provides the Cargo.lock that cargoDeps expects
    root-dep: extra-dep-list:
    runCommand "merge-vendor-deps" { } ''
      mkdir -p $out

      cp -r --no-preserve=mode "${root-dep}/." "$out/"

      ${lib.join "\n" (lib.map copyCargoDeps extra-dep-list)}
    '';
  src = fetchFromGitHub {
    owner = "fluxerapp";
    repo = "fluxer";
    inherit (fluxerHashes) rev hash;
  };
  cargoPrimaryDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    inherit (fluxerHashes.cargo) hash;
  };
  cargoLibFluxcoreDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = fluxerHashes.cargo.libFluxcore;
    sourceRoot = "${src.name}/fluxer_app/rust/libfluxcore";
  };
  cargoLibFluxwebpDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = fluxerHashes.cargo.libFluxwebp;
    sourceRoot = "${src.name}/fluxer_app/rust/libfluxwebp";
  };
  cargoLibGuildMemberListNifDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = fluxerHashes.cargo.libGuildMemberListNif;
    sourceRoot = "${src.name}/fluxer_gateway/native/guild_member_list_oset_nif";
  };
  cargoLibMarkdownPlaintextNifDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = fluxerHashes.cargo.libPushMarkdownPlaintext;
    sourceRoot = "${src.name}/fluxer_gateway/native/push_markdown_plaintext_nif";
  };
  cargoDeps = mergeCargoDeps cargoPrimaryDeps [
    cargoLibFluxcoreDeps
    cargoLibFluxwebpDeps
    cargoLibGuildMemberListNifDeps
    cargoLibMarkdownPlaintextNifDeps
  ];

  # hooks
  adminPostInstallHook = ''
    mv $out/bin/fluxer_admin $out/bin/fluxer-admin
  '';
  apiPostBuildHook = ''
    pnpm --filter fluxer_api run build
  '';
  apiPostInstallHook = ''
    mkdir -p $out/lib/fluxer-api-deps

    pnpm config set --location=project injectWorkspacePackages true
    pnpm deploy \
      --filter=fluxer_api \
      --prod \
      $out/lib/fluxer-api

    mkdir -p $out/lib/fluxer-api
    cp -r fluxer_api/dist $out/lib/fluxer-api/dist

    makeWrapper ${lib.getExe nodejs} $out/bin/fluxer-api \
      --add-flags "$out/lib/fluxer-api/dist/AppEntrypoint.js"

    makeWrapper ${lib.getExe nodejs} $out/bin/fluxer-api-worker \
      --add-flags "$out/lib/fluxer-api/dist/WorkerEntrypoint.js"
  '';
  appProxyPostPatchHook = ''
    patchShebangs --build tools/ci/run.sh
    patchShebangs --build fluxer_app_proxy/scripts/precompress_assets.sh
  '';
  appProxyPostBuildHook = ''
    (
      unset CARGO_TARGET_DIR
      cd fluxer_app
      pnpm build
    )

    bash fluxer_app_proxy/scripts/precompress_assets.sh fluxer_app/dist
  '';
  appProxyPostInstallHook = ''
    mkdir -p $out/share/fluxer_app_proxy
    cp -r fluxer_app/dist/* $out/share/fluxer_app_proxy

    wrapProgram $out/bin/fluxer_app_proxy \
      --set-default FLUXER_STATIC_DIR $out/share/fluxer_app_proxy

    mv $out/bin/fluxer_app_proxy $out/bin/fluxer-app-proxy
  '';
  mediaProxyPostInstallHook = ''
    wrapProgram $out/bin/fluxer-media-proxy \
      --suffix LD_PRELOAD : ${jemalloc}/lib/libjemalloc.so \
      --set-default MALLOC_CONF "background_thread:true,metadata_thp:auto,dirty_decay_ms:5000,muzzy_decay_ms:5000" \
      --set-default VIPS_CONCURRENCY 1 \
      --set-default VIPS_DISC_THRESHOLD 1g
  '';
  staticPostInstallHook = ''
    mkdir -p $out/share/fluxer-static

    cp -r fluxer_static/* $out/share/fluxer-static
  '';
in
rustPlatform.buildRustPackage (
  finalAttrs:
  let
    fluxer-gateway = beamPackages.rebar3Relx {
      pname = "fluxer-gateway";
      inherit (finalAttrs) src version;

      __structuredAttrs = true;

      releaseType = "release";
      profile = "prod";

      env.REBAR_SKIP_PROJECT_PLUGINS = "1";

      nativeBuildInputs = [
        cargo
        rustc
        rustPlatform.cargoSetupHook
        makeWrapper
      ];

      buildInputs = [
        coreutils
        gawk
      ];

      checkouts =
        (beamPackages.fetchRebar3Deps {
          inherit (finalAttrs) version;
          name = "fluxer-gateway-deps-0";
          src = "${finalAttrs.src}/fluxer_gateway";
          sha256 = fluxerHashes.rebar;
        }).overrideAttrs
          (
            final: prev: {
              nativeBuildInputs = (prev.nativeBuildInputs or [ ]) ++ [
                git
                cacert
              ];
              postInstall = ''
                find $out -name .git -prune -execdir rm -r {} +
              '';
            }
          );

      cargoDeps = finalAttrs.cargoDeps;

      postPatch = ''
        cp fluxer_gateway/config/sys.config{.template,}

        patchShebangs --build tools/ci/run.sh
      '';

      preConfigure = ''
        cd fluxer_gateway
      '';

      postConfigure =
        let
          pkg = "eqwalizer_support";
        in
        ''
          mv _checkouts/${pkg}/${pkg} intermediate-dir
          rm -r _checkouts/${pkg}
          mv intermediate-dir _checkouts/${pkg}

          substituteInPlace _checkouts/ezstd/Makefile \
            --replace-fail '@./build_deps.sh' '@${lib.getExe bash} build_deps.sh'

          # Prevent ezstd from fetching and building its own zstd
          mkdir -p _checkouts/ezstd/_build/deps/zstd/lib
          cp ${zstd.dev}/include/*.h _checkouts/ezstd/_build/deps/zstd/lib
          cp ${zstdStatic.out}/lib/libzstd.a _checkouts/ezstd/_build/deps/zstd/lib
        '';

      postFixup = ''
        mv $out/bin/fluxer_gateway $out/bin/.fluxer_gateway

        install --mode=0755 scripts/docker_entrypoint.sh $out/bin/fluxer-gateway
        substituteInPlace $out/bin/fluxer-gateway \
          --replace-fail "#!/usr/bin/env sh" "#!${lib.getExe bash}" \
          --replace-fail "/opt/fluxer_gateway/bin/fluxer_gateway" "$out/bin/.fluxer_gateway"

        wrapProgram $out/bin/fluxer-gateway \
          --set-default FLUXER_ERLANG_NODE_NAME fluxer-gateway@127.0.0.1 \
          --run 'export RELX_OUT_FILE_PATH="''${RELX_OUT_FILE_PATH:-$(mktemp -d)}"' \
          --prefix PATH : "${
            lib.makeBinPath [
              coreutils
              gawk
            ]
          }"
      '';
    };
  in
  {
    pname = "fluxer-server";
    inherit (fluxerHashes) version;

    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "fluxerapp";
      repo = "fluxer";
      inherit (fluxerHashes) rev hash;
    };

    env.npm_config_nodedir = nodejs;
    env.BUNDLE_LOCAL_ASSETS = true;

    inherit cargoDeps;

    pnpmDeps = fetchPnpmDeps {
      inherit src;
      inherit pnpm;
      pname = "fluxer-pnpm-deps-0";
      fetcherVersion = 4;
      hash = fluxerHashes.pnpm;
    };

    nativeBuildInputs = [
      nasm
      yasm
      pkg-config
      makeWrapper
      tailwindcss_4
      nodejs
      pnpm
      pnpmConfigHook
      cargo
      clang.cc
      lld
      brotli
      wasm-bindgen-cli
    ];

    nativeCheckInputs = [
      cacert
    ];

    buildInputs = [
      zlib
      vips
      libheif
      ffmpeg-headless
      lcms2
      libwebp
      libyuv
      libde265
      dav1d
      libaom
      jemalloc
    ];

    buildFeatures = [
      "scylla"
    ];

    postPatch = ''
      ${appProxyPostPatchHook}
    '';

    postBuild = ''
      ${apiPostBuildHook}
      ${appProxyPostBuildHook}
    '';

    postInstall = ''
      ${adminPostInstallHook}
      ${apiPostInstallHook}
      ${appProxyPostInstallHook}
      ${mediaProxyPostInstallHook}
      ${staticPostInstallHook}

      cp ${fluxer-gateway}/bin/* $out/bin/
    '';

    passthru = {
      updateScript = ./update.py;
    };

    meta = {
      description = "Rust packages for Fluxer, a free and open source instant messaging and VoIP chat app";
      license = with lib.licenses; [
        agpl3Plus # fluxer
        cc-by-40 # fluxer_app/src/media/images/i-like-food.svg
        mit # fluxer_app/src/media/images/neko.png, fluxer_app/src/features/accessibility/components/NekoSprite.tsx
        asl20 # fluxer_app/src/features/ui/components/icons/InboxIcon.tsx
      ];
      homepage = "https://github.com/fluxerapp/fluxer";
      maintainers = [ lib.maintainers.strangeglyph ];

    };
  }
)
