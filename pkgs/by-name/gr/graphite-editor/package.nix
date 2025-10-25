{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchurl,
  fetchNpmDeps,
  makeWrapper,
  rustc,
  cargo,
  npmHooks,
  lld,
  llvm,
  binaryen,
  wasm-pack,
  cargo-about,
  nodejs,
  pkg-config,
  wasm-bindgen-cli_0_2_100,
  libcef,
  wayland,
  openssl,
  vulkan-loader,
  mesa,
  libraw,
  libGL,
}:

let
  version = "0-unstable-2025-10-12";
  rev = "84f1b65d079561d94a16fb77699b63f25f65ba37";

  srcHash = "sha256-JxvE4yHjKdV0tQVtW8KLLItM+CxtHrHP+6csqxFeJcs=";
  shadersHash = "sha256-ovE4TT7UaAMdhh4/s+bkCg/YQA2cItkMIvsq0BGPaAc=";
  cargoHash = "sha256-6uYpMbAfxM7Nq5s+LrrL/9J5wU/rgAJFmWYmLqgzH6g=";
  npmHash = "sha256-UWuJpKNYj2Xn34rpMDZ75pzMYUOLQjPeGuJ/QlPbX9A=";

  binName = "graphite-editor";

  src = fetchFromGitHub {
    owner = "GraphiteEditor";
    repo = "Graphite";
    inherit rev;
    hash = srcHash;
  };

  shaders = fetchurl {
    url = "https://raw.githubusercontent.com/timon-schelling/graphite-artifacts/refs/heads/main/rev/${rev}/graphene_raster_nodes_shaders_entrypoint.wgsl";
    hash = shadersHash;
  };

  resources = stdenv.mkDerivation (finalAttrs: {
    pname = "graphite-editor-resources";
    inherit version;

    inherit src;

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
      llvm
      binaryen
      wasm-pack
      nodejs
      pkg-config
      wasm-bindgen-cli_0_2_100
      cargo-about
      makeWrapper
    ];

    npmBuildScript = "build-desktop";

    buildPhase = ''
      cd frontend
      npm run ${finalAttrs.npmBuildScript}
    '';

    installPhase = ''
      mkdir -p $out
      cp -r dist/* $out
    '';
  });

  libraries = [
    openssl
    vulkan-loader
    mesa
    libraw
    wayland
    libGL
  ];
  cefPath = stdenv.mkDerivation {
    pname = "cef-path";
    version = libcef.version;
    dontUnpack = true;
    installPhase = ''
      mkdir -p "$out"
      find ${libcef}/lib -type f -name "*" -exec cp {} $out/ \;
      find ${libcef}/libexec -type f -name "*" -exec cp {} $out/ \;
      cp -r ${libcef}/share/cef/* $out/

      mkdir -p "$out/include"
      cp -r ${libcef}/include/* "$out/include/"
    '';
    postFixup = ''
      strip $out/*.so*
    '';
  };
  libraryPath = "${lib.makeLibraryPath libraries}:${cefPath}";

  native = rustPlatform.buildRustPackage (finalAttrs: {
    pname = "graphite-editor-native-application";
    inherit version;

    inherit src;

    inherit cargoHash;

    nativeBuildInputs = [
      pkg-config
      lld
      llvm
      makeWrapper
    ];

    buildInputs = libraries;

    # Remove cef version check
    postPatch = ''
      substituteInPlace $cargoDepsCopy/cef-dll-sys-*/build.rs \
        --replace-fail 'download_cef::check_archive_json(&env::var("CARGO_PKG_VERSION")?, &cef_path)?;' '''
    '';

    env.CEF_PATH = cefPath;
    env.GRAPHENE_RASTER_NODES_SHADER_PATH = shaders;
    cargoBuildFlags = [
      "-p"
      "graphite-desktop"
      "--no-default-features"
      "--features"
      "recommended"
    ];

    postInstall = ''
      mkdir -p $out/share/applications
      cp $src/desktop/assets/*.desktop $out/share/applications/

      mkdir -p $out/share/icons/hicolor/scalable/apps
      cp $src/desktop/assets/graphite-icon-color.svg $out/share/icons/hicolor/scalable/apps/
    '';

    postFixup = ''
      mv $out/bin/graphite-desktop $out/bin/${binName}

      wrapProgram "$out/bin/${binName}" \
        --prefix LD_LIBRARY_PATH : "${libraryPath}" \
        --set CEF_PATH "${cefPath}"
    '';

    # There are currently no tests for the desktop application
    doCheck = false;

    meta.mainProgram = binName;
  });

  bin = lib.getExe native;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "graphite-editor";
  inherit version;

  phases = [ "installPhase" ];

  inherit resources;

  installPhase = ''
    mkdir -p $out/bin

    cat > $out/bin/graphite-editor <<'EOF'
    #!${stdenv.shell}
    export GRAPHITE_RESOURCES=${finalAttrs.resources}
    exec ${bin} "$@"
    EOF

    chmod +x $out/bin/graphite-editor

    mkdir -p $out/share
    cp -r ${native}/share/* $out/share/
  '';

  meta = {
    description = "2D vector & raster editor that melds traditional layers & tools with a modern node-based, non-destructive, procedural workflow";
    homepage = "https://github.com/GraphiteEditor/Graphite";

    # All of Graphite's code is licensed under Apache-2.0 license.
    #
    # However, this derivation also bundles the default iconset which is owned by the official Graphite project.
    # NixOS is permitted to redistribute full Graphite sources and binaries,
    # including the default iconset build from the official Graphite repository.
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ timon ];
    mainProgram = binName;
  };
})
