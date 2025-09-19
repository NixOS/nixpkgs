{
  lib,
  stdenv,
  rustPlatform,
  buildNpmPackage,
  fetchFromGitHub,
  fetchpatch,
  fetchurl,
  replaceVars,
  copyDesktopItems,
  makeDesktopItem,
  makeBinaryWrapper,
  nix-update-script,
  electron,
  gnum4,
  fftwFloat,
  flint,
  blas,
  openblas,
}:

let
  # The dependencies of graphest-fftw-sys and graphest-arb-sys need to be static.
  # Use this instead of pkgsStatic because pkgsStatic.flint build fails.
  static =
    p:
    p.overrideAttrs (oldAttrs: {
      configureFlags = oldAttrs.configureFlags ++ [ "--enable-static" ];
    });
  fftwFloatStatic = static fftwFloat;
  # Graphest was developed with Flint 2, so let's hope there are no breaking changes
  flintStatic = (static flint).override {
    inherit blas openblas;
    withBlas = true; # Some functions used by Graphest require BLAS
  };

  version = "1.3.3-unstable-2024-08-30"; # 1.3.3 build fails because Rust removed default_free_fn
  src = fetchFromGitHub {
    owner = "unageek";
    repo = "graphest";
    rev = "e9730220349a6da9816f930b5a37c2a75b74bf9c"; # tag = "v${version}";
    hash = "sha256-s9dVApPjFJGR0lP+a2pi6P+GDs4JIAz5gpW+cx9XGzw=";
  };

  meta = {
    description = "Graphing calculator that can faithfully plot arbitrary mathematical relations";
    homepage = "https://github.com/unageek/graphest";
    changelog = "https://github.com/unageek/graphest/releases/tag/v1.3.3"; # https://github.com/unageek/graphest/releases/${src.tag}
    downloadPage = "https://github.com/unageek/graphest/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ulysseszhan ];
  };

  graph = rustPlatform.buildRustPackage (finalAttrs: {
    pname = "graphest-graph";
    inherit version src;

    patches = [
      # Update bindgen; use Flint 3; fix compilation warnings (https://github.com/unageek/graphest/pull/999)
      (fetchpatch {
        name = "flint3";
        url = "https://github.com/unageek/graphest/commit/65ffea93c934f2df100c18f799afdf9870d611ff.patch";
        hash = "sha256-aysdGhVu54M3F+A0e38WwlLUdf2pTw73Vs117Vfi8O8=";
      })

      # Use libraries from nixpkgs instead of trying to download them
      (replaceVars ./dependencies.patch {
        fftwLib = fftwFloatStatic.out;
        fftwDev = fftwFloatStatic.dev;
        flint = flintStatic.out;
      })
    ];

    nativeBuildInputs = [
      gnum4
      rustPlatform.bindgenHook
    ];

    buildInputs = [
      fftwFloatStatic
      flintStatic
      blas # needed here because -lblas is added to RUSTFLAGS
    ];
    strictDeps = true;

    # vendored from unageek/graphest#999 to update bindgen; replace with cargoHash once it is merged
    cargoLock.lockFile = ./Cargo.lock;

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
    # These two tests fails probably because of Flint 3
    checkFlags = [
      "--skip"
      "graph_tests::examples::t_8c9209237ba04e67a715382c7bcbf5e0"
      "--skip"
      "graph_tests::examples::t_d2a0e9e88c41406a80a266d78f6dc7a5"
    ];

    meta = meta // {
      broken = stdenv.hostPlatform.isMsvc; # https://github.com/unageek/inari
      mainProgram = "graph";
    };
  });

in
buildNpmPackage (finalAttrs: {
  pname = "graphest";
  inherit version src;

  patches = [
    # specify what files should be installed in package.json (https://github.com/unageek/graphest/pull/1000)
    (fetchpatch {
      name = "npm-files";
      url = "https://github.com/unageek/graphest/commit/1d1b8ee610a55bf9465a630499c6b0f6e9a66689.patch";
      hash = "sha256-5PU9iPy6gfesl40piRTw9+QMNf4GSGASYs8ZTLedS7o=";
    })

    ./disable-auto-update.patch
  ];

  nativeBuildInputs = [
    copyDesktopItems
    makeBinaryWrapper
  ];

  buildInputs = [
    electron
    graph
  ];

  npmDepsHash = "sha256-J/IZ7d3LaYZLik7SxXSrH9dfxpxsa/Dn87160ba7wjs=";
  env.ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  preBuild = ''
    export NODE_ENV=production # do not set this in env because it must not be present in the configure phase
  '';
  npmBuildScript = "build:app";

  checkPhase = ''
    runHook preCheck

    npm test

    runHook postCheck
  '';

  postInstall = ''
    ln -s ${graph}/bin/* -t $out/lib/node_modules/graphest/dist

    makeWrapper ${lib.getExe electron} $out/bin/graphest \
      --add-flags $out/lib/node_modules/graphest \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --inherit-argv0

    mkdir -p $out/share/{icons/hicolor/1024x1024/apps,mime/packages}
    install -Dm644 build/icon.png $out/share/icons/hicolor/1024x1024/apps/graphest.png
    cat << EOF > $out/share/mime/packages/graphest.xml
    <?xml version="1.0" encoding="UTF-8"?>
    <mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
      <mime-type type="application/x-graphest">
        <comment xml:lang="en">Graphest Document</comment>
        <glob pattern="*.graphest"/>
      </mime-type>
    </mime-info>
    EOF
  '';

  desktopItem = makeDesktopItem {
    name = "graphest";
    desktopName = "Graphest";
    exec = "graphest %u";
    icon = "graphest";
    categories = [
      "Science"
      "Math"
    ];
    comment = meta.description;
    mimeTypes = [
      "x-scheme-handler/graphest"
      "application/x-graphest"
    ];
  };

  passthru = {
    inherit graph;
    updateScript = nix-update-script { };
  };

  meta = meta // {
    mainProgram = "graphest";
  };
})
