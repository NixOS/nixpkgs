{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  replaceVars,
  copyDesktopItems,
  makeDesktopItem,
  makeBinaryWrapper,
  nix-update-script,
  nodejs,
  electron,
  gnum4,
  pkgsStatic,
  blas,
  darwin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "graphest";
  # 1.8.2 cannot build due to https://github.com/NixOS/nixpkgs/issues/483500
  version = "1.8.2-unstable-2026-01-21";

  src = fetchFromGitHub {
    owner = "unageek";
    repo = "graphest";
    rev = "2bcb478acd40a1174606e51f4affeca56446c9f6";
    hash = "sha256-+onb21xb8nhEKIL/B8sNufWaPVhABnpU3uIyRn4ISWQ=";
  };

  patches = [
    # specify what files should be installed in package.json (https://github.com/unageek/graphest/pull/1000)
    # not accepted by upstream because the developer did not intend to publish as an npm package
    (fetchpatch {
      name = "npm-files";
      url = "https://github.com/unageek/graphest/commit/1d1b8ee610a55bf9465a630499c6b0f6e9a66689.patch";
      hash = "sha256-5PU9iPy6gfesl40piRTw9+QMNf4GSGASYs8ZTLedS7o=";
    })

    # support opening file or url from command line (https://github.com/unageek/graphest/pull/1002)
    # otherwise the desktop entry is basically useless
    (fetchpatch {
      name = "open-file";
      url = "https://github.com/unageek/graphest/commit/05f2e486a5cdd79d5135057d67c398256dc5019c.patch";
      hash = "sha256-GkssYkHVps8PeHMX/Fj5uj6r+MLrZcETXtQq4mZcOrQ=";
    })

    ./disable-auto-update.patch
  ];

  nativeBuildInputs = [
    copyDesktopItems
    makeBinaryWrapper
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin darwin.autoSignDarwinBinariesHook;

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-krpJflsoUPIzhdtyQu3WmapM4C63adwOq2Q6inUa3Xk=";
  };
  env.ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  preBuild = ''
    # do not set this in env because it must not be present in the configure phase
    export NODE_ENV=production
  '';
  yarnBuildScript = "build:app";

  checkPhase = ''
    runHook preCheck

    yarn test

    runHook postCheck
  '';

  postInstall = ''
    ln -s ${finalAttrs.passthru.graph}/bin/* -t $out/lib/node_modules/graphest/dist

    makeWrapper ${lib.getExe electron} $out/bin/Graphest \
      --add-flags $out/lib/node_modules/graphest \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --inherit-argv0

    install -Dm444 build/icon.png $out/share/icons/hicolor/1024x1024/apps/graphest.png
    install -Dm444 ${./mime.xml} $out/share/mime/packages/graphest.xml
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications/Graphest.app/Contents/MacOS
    ln -s $out/bin/Graphest $out/Applications/Graphest.app/Contents/MacOS/Graphest
    install -Dm444 build/icon.icns $out/Applications/Graphest.app/Contents/Resources/icon.icns
    install -Dm444 ${
      # This is adapted from the extracted contents of the dmg package.
      # It should be generated from electron-builder.json,
      # but apparently electron-builder does not have a functionality for just generating Info.plist instead of everything.
      replaceVars ./Info.plist {
        version = builtins.elemAt (builtins.match "([^\\-]+).*" finalAttrs.version) 0;
      }
    } $out/Applications/Graphest.app/Contents/Info.plist
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "graphest";
      desktopName = "Graphest";
      exec = "Graphest %u";
      icon = "graphest";
      categories = [
        "Science"
        "Math"
      ];
      comment = finalAttrs.meta.description;
      mimeTypes = [
        "x-scheme-handler/graphest"
        "application/x-graphest"
      ];
    })
  ];

  passthru = {
    updateScript = nix-update-script { };

    # The dependencies of graphest-fftw-sys and graphest-arb-sys need to be static.
    fftwFloatStatic = pkgsStatic.fftwFloat;
    flintStatic = pkgsStatic.flint.override {
      withBlas = true; # Some functions used by Graphest require BLAS
    };

    graph = rustPlatform.buildRustPackage {
      pname = "graphest-graph";
      inherit (finalAttrs) version src;

      patches = [
        # Use libraries from nixpkgs instead of trying to download them
        (replaceVars ./dependencies.patch {
          fftwLib = finalAttrs.passthru.fftwFloatStatic.out;
          fftwDev = finalAttrs.passthru.fftwFloatStatic.dev;
          flint = finalAttrs.passthru.flintStatic.out;
        })
      ];

      nativeBuildInputs = [
        gnum4 # used by build script of gmp-mpfr-sys
        rustPlatform.bindgenHook # used by build script of graphest-fftw-sys and graphest-arb-sys even on linux
      ];

      buildInputs = [
        blas # needed here because -lblas is added to RUSTFLAGS
      ];
      strictDeps = true;

      cargoHash = "sha256-GC0BHLWRKw6ThQiIfFQoOcGq9Xm0I9rt8uhwyalCa2I=";

      env = {
        RUSTC_BOOTSTRAP = 1; # smallvec: error[E0554]: `#![feature]` may not be used on the stable release channel
        RUSTFLAGS =
          "-lblas" # add -lblas to fix linking error regarding the function cblas_dgemm (bug of flint maybe???)
          # inari: error: RUSTFLAGS='-Ctarget-cpu=haswell' or later is required.
          + lib.optionalString stdenv.hostPlatform.isx86 " -Ctarget-cpu=haswell";
      };

      preCheck = ''
        # see rust/tests/graph.rs; executable path is hardcoded to be in target/release
        ln -s ../${stdenv.targetPlatform.rust.rustcTargetSpec}/release/graph -t target/release
      '';
      # TODO: These tests fail for unknown reasons.
      checkFlags = [
        "--skip=graph_tests::examples::t_564aaa5e88a54895b1851a1f1e5ffa3c"
        "--skip=graph_tests::examples::t_8c9209237ba04e67a715382c7bcbf5e0"
        "--skip=graph_tests::examples::t_b0175d3b58ed46158ba72bbd85670fc9"
        "--skip=graph_tests::examples::t_d2a0e9e88c41406a80a266d78f6dc7a5"
        "--skip=graph_tests::implicit::t_7f25b9f2bd3746b3ae8f95a82921de2b"
        "--skip=graph_tests::implicit::t_84a2738be35745da97a9b120c563b4b3"
      ];

      meta = finalAttrs.meta // {
        # See README of https://github.com/unageek/inari:
        # limited to platforms that are supported by the gmp-mpfr-sys crate.
        broken = stdenv.hostPlatform.isMsvc;
        mainProgram = "graph";
      };
    };
  };

  meta = {
    description = "Graphing calculator that can faithfully plot arbitrary mathematical relations";
    homepage = "https://github.com/unageek/graphest";
    changelog = "https://github.com/unageek/graphest/releases";
    downloadPage = "https://github.com/unageek/graphest/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    mainProgram = "Graphest";
  };
})
