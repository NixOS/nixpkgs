{
  lib,
  stdenv,
  rustPlatform,
  runCommand,
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
  cef-binary,
  wayland,
  openssl,
  vulkan-loader,
  mesa,
  libraw,
  libGL,
}:

let
  version = "0-unstable-2025-12-01";
  rev = "1a973e748701cc639a8a035b72e7678e445bbef7";

  srcHash = "sha256-LgG491iIHbhrT9Vc+VOwGoiSVeeky/rllGvB+o9nja8=";
  shaderHash = "sha256-uc6FU0df5Xqp6YXEwODULhgUjSQvjRFGvdk+uFB7II0=";
  cargoHash = "sha256-TkwjntAriuTnxBbIHjkXQw0w3bA9/ZHv4jC8BLRmbZk=";
  npmHash = "sha256-D8VCNK+Ca3gxO+5wriBn8FszG8/x8n/zM6/MPo9E2j4=";

  brandingRev = "f8b02e68c92f5bbd27626bdd7a51102303b70a40";
  brandingHash = "d06fd7b79fa9b7509c23072fa56745415fdc6eb98575d15214b0acc47ea4dd42";

  binName = "graphite";

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

  brandingTar = fetchurl {
    url = "https://github.com/Keavon/graphite-branded-assets/archive/${brandingRev}.tar.gz";
    sha256 = brandingHash;
  };
  branding = runCommand "graphite-editor-branding" { } ''
    mkdir -p $out
    tar -xvf ${brandingTar} -C $out --strip-components 1
  '';

  resources = stdenv.mkDerivation (finalAttrs: {
    pname = "graphite-editor-resources";
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
      llvm
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
      export HOME="$TMPDIR"

      pushd frontend
      npm run native:build-production
      popd
    '';

    installPhase = ''
      mkdir -p $out
      cp -r frontend/dist/* $out/
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
  cef = cef-binary.overrideAttrs (
    _: _: {
      postInstall = ''
        strip $out/Release/*.so*
      '';
    }
  );

  cefPath = runCommand "cef-path" { } ''
    mkdir -p $out

    ln -s ${cef}/include $out/include
    find ${cef}/Release -name "*" -type f -exec ln -s {} $out/ \;
    find ${cef}/Resources -name "*" -maxdepth 1 -exec ln -s {} $out/ \;

    echo '${
      builtins.toJSON {
        type = "minimal";
        name = builtins.baseNameOf cef.src.url;
        sha1 = "";
      }
    }' > $out/archive.json
  '';
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

    env.CEF_PATH = cefPath;
    env.RASTER_NODES_SHADER_PATH = shaders;
    cargoBuildFlags = [
      "-p"
      "graphite-desktop"
      "--no-default-features"
      "--features"
      "recommended"
    ];

    postUnpack = ''
      mkdir ./branding
      cp -r ${branding}/* ./branding
    '';

    postInstall = ''
      mkdir -p $out/share/applications
      cp $src/desktop/assets/*.desktop $out/share/applications/

      mkdir -p $out/share/icons/hicolor/scalable/apps
      cp ${branding}/app-icons/graphite.svg $out/share/icons/hicolor/scalable/apps/
    '';

    postFixup = ''
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

    cat > $out/bin/graphite <<'EOF'
    #!${stdenv.shell}
    export GRAPHITE_RESOURCES=${finalAttrs.resources}
    exec ${bin} "$@"
    EOF

    chmod +x $out/bin/graphite

    mkdir -p $out/share
    cp -r ${native}/share/* $out/share/
  '';

  meta = {
    description = "2D vector & raster editor that melds traditional layers & tools with a modern node-based, non-destructive, procedural workflow";
    homepage = "https://github.com/GraphiteEditor/Graphite";

    # All of Graphite's code is licensed under Apache-2.0 license.
    #
    # However, this derivation also bundles the official branding which is owned by the Graphite project.
    # NixOS is permitted to redistribute full Graphite sources and binaries, including the official branding.
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ timon ];
    mainProgram = binName;
  };
})
