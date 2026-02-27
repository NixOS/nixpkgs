{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchurl,
  fetchzip,
  fetchNpmDeps,
  symlinkJoin,
  makeWrapper,
  rustc,
  cargo,
  npmHooks,
  writableTmpDirAsHomeHook,
  lld,
  binaryen,
  wasm-pack,
  cargo-about,
  nodejs,
  pkg-config,
  wasm-bindgen-cli_0_2_100,
  cef-binary,
  wayland,
  openssl,
  vulkan-loader,
  libGL,
  libxkbcommon,
  libxcursor,
  libx11,
  libxcb,
}:

let
  version = "0-unstable-2026-01-27";
  rev = "84e9d8c192bdf49e88e2aefe422656f8f47b3a6a";

  srcHash = "sha256-Prqm6/ttmCxH99bqQC26qEyOuC3NlTw0kFADJvA4jbw=";
  shaderHash = "sha256-uc6FU0df5Xqp6YXEwODULhgUjSQvjRFGvdk+uFB7II0=";
  cargoHash = "sha256-QvqvguS3KHJVGZJqpkRRZU7clVTfRJHkv6WygaAHOdM=";
  npmHash = "sha256-TNoRGR4kWUmY0XDhpjWKudQ5e33gSl72YnXLx96NdLY=";

  brandingRev = "f44aa2f362ae4fed8d634878b817a1d3948a7dcb";
  brandingHash = "sha256-3w086pZTw6PUlEAYFGkGD8q+EMtuy23YqunxJTxCPLc=";

  src = fetchFromGitHub {
    owner = "GraphiteEditor";
    repo = "Graphite";
    inherit rev;
    hash = srcHash;
  };

  shaders = fetchurl {
    url = "https://raw.githubusercontent.com/timon-schelling/graphite-artifacts/refs/heads/main/rev/${rev}/raster_nodes_shaders_entrypoint.wgsl";
    hash = shaderHash;
  };

  branding = fetchzip {
    url = "https://github.com/Keavon/graphite-branded-assets/archive/${brandingRev}.tar.gz";
    hash = brandingHash;
  };

  resources = stdenv.mkDerivation (finalAttrs: {
    pname = "graphite-resources";
    inherit version src;

    cargoDeps = rustPlatform.fetchCargoVendor {
      src = finalAttrs.src;
      sourceRoot = finalAttrs.src.name;
      hash = cargoHash;
    };

    npmDeps = fetchNpmDeps {
      inherit (finalAttrs) pname version;
      src = "${finalAttrs.src}/frontend";
      hash = npmHash;
    };

    npmRoot = "frontend";
    npmConfigScript = "setup";
    makeCacheWritable = true;

    nativeBuildInputs = [
      rustPlatform.cargoSetupHook
      rustc
      cargo
      npmHooks.npmConfigHook
      lld
      writableTmpDirAsHomeHook
      binaryen
      wasm-pack
      nodejs
      pkg-config
      wasm-bindgen-cli_0_2_100
      cargo-about
      makeWrapper
    ];

    prePatch = ''
      mkdir branding
      cp -r ${branding}/* branding
      cp $src/.branding branding/.branding
    '';

    buildPhase = ''
      runHook preBuild
      pushd frontend
      npm run native:build-production
      popd
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r frontend/dist/* $out/
      runHook postInstall
    '';
  });

  libraries = [
    stdenv.cc.cc.lib
    stdenv.cc.libc.out
    vulkan-loader
    libGL
    wayland
    openssl
    libxkbcommon
    libxcursor
    libxcb
    libx11
  ];
  cef = cef-binary.overrideAttrs {
    postFixup = ''
      strip $out/Release/*.so*
    '';
  };
  cefPath = symlinkJoin {
    name = "cef-path";
    paths = [
      "${cef}/Release"
      "${cef}/Resources"
    ];
    postBuild = ''
      ln -s ${cef}/include $out/include
      echo '${
        builtins.toJSON {
          type = "minimal";
          name = builtins.baseNameOf cef.src.url;
          sha1 = "";
        }
      }' > $out/archive.json
    '';
  };
in
rustPlatform.buildRustPackage {
  pname = "graphite";
  inherit version src cargoHash;

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = libraries;

  env.CEF_PATH = cefPath;
  env.RASTER_NODES_SHADER_PATH = shaders;
  env.EMBEDDED_RESOURCES = resources;
  cargoBuildFlags = [
    "-p"
    "graphite-desktop"
  ];

  postUnpack = ''
    mkdir ./branding
    cp -r ${branding}/* ./branding
  '';

  postInstall = ''
    mkdir -p $out/share/applications
    cp $src/desktop/assets/*.desktop $out/share/applications/

    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp ${branding}/app-icons/graphite.svg $out/share/icons/hicolor/scalable/apps/art.graphite.Graphite.svg
  '';

  postFixup = ''
    patchelf \
      --set-rpath "${lib.makeLibraryPath libraries}:${cefPath}" \
      --add-needed libGL.so \
      $out/bin/graphite
  '';

  # There are currently no tests for the desktop application
  doCheck = false;

  meta = {
    description = "Open source vector graphics editor and procedural design engine";
    homepage = "https://graphite.art";
    mainProgram = "graphite";
    longDescription = ''
      Graphite is an open source vector graphics editor and procedural design engine.
      Create and animate with a nondestructive editing workflow that
      combines layer-based compositing with node-based generative design.
    '';

    # All Graphite code is licensed under the Apache License 2.0.
    # This derivation also bundles the official branding assets
    # which are licensed under the separate Graphite Branding License.
    license = with lib.licenses; [
      asl20
      {
        fullName = "Graphite Branding License";
        url = "https://graphite.art/license/#branding";
        free = false;
        redistributable = true;
      }
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ timon ];
  };
}
