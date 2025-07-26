{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  runCommand,
  makeWrapper,
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
  cef = libcef.overrideAttrs (
    finalAttrs: previousAttrs: {
      # Version needs to match the version used by cef crate
      version = "138.0.26";
      gitRevision = "84f2d27";
      chromiumVersion = "138.0.7204.158";
      srcHash = "sha256-d9jQJX7rgdoHfROD3zmOdMSesRdKE3slB5ZV+U2wlbQ=";

      # libcef uses finalAttrs.version while fetching src therefore we don't need to override src
      __intentionallyOverridingVersion = true;

      # strip debug symbols to reduce size
      postInstall = ''
        strip $out/lib/*
      '';
    }
  );

  cefRsCompatibleLibCef = runCommand "cef-rs-compatible-libcef" { } ''
    mkdir -p $out/lib

    ln -s ${cef}/include $out/lib/include
    find ${cef}/lib -type f -name "*" -exec ln -s {} $out/lib/ \;
    find ${cef}/libexec -type f -name "*" -exec ln -s {} $out/lib/ \;
    cp -r ${cef}/share/cef/* $out/lib/

    echo '${
      builtins.toJSON {
        type = "minimal";
        name = builtins.baseNameOf cef.src.url;
        sha1 = "";
      }
    }' > $out/lib/archive.json
  '';
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "graphite-desktop";
  version = "unstable-2025-07-23";

  src = fetchFromGitHub {
    owner = "GraphiteEditor";
    repo = "graphite";
    rev = "a52ee70e4cd43ea2835fc3bc671547452bb2c790";
    hash = "sha256-tRfWd10eqmkWk0RoY6F8e0KWXcslYW3HYfxUWYq3dvI=";
  };

  cargoHash = "sha256-Jmz8ps649yl9xPsQ/Ihus+3MsVTECaIvVsquUUDOJO0=";

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) pname version;
    src = "${finalAttrs.src}/frontend";
    hash = "sha256-XXD04aIPasjHtdOE/mcQ7TocRlSfzHGLiYNFWOPHVrM=";
  };

  buildAndTestSubdir = "desktop";
  npmRoot = "frontend";
  npmConfigScript = "setup";

  nativeBuildInputs = [
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

  buildInputs = [
    openssl
    vulkan-loader
    mesa
    libraw
    wayland
    libGL
    cefRsCompatibleLibCef
  ];

  preBuild = ''
    pushd frontend

    npm run build

    popd
  '';

  env.CEF_PATH = "${cefRsCompatibleLibCef}/lib";
  cargoBuildFlags = [
    "-p"
    "graphite-desktop"
  ];

  postFixup = ''
    wrapProgram "$out/bin/graphite-desktop" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}" \
      --set CEF_PATH "${cefRsCompatibleLibCef}/lib"
  '';

  # There are currently no tests for the desktop application
  doCheck = false;

  meta = {
    description = "2D vector & raster editor that melds traditional layers & tools with a modern node-based, non-destructive, procedural workflow";
    homepage = "https://github.com/GraphiteEditor/Graphite";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ timon ];
    mainProgram = "graphite-desktop";
  };
})
