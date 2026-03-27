{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  fetchzip,
  rustPlatform,
  fetchNpmDeps,
  rustc,
  cargo,
  npmHooks,
  lld,
  pkg-config,
  binaryen,
  wasm-pack,
  cargo-about,
  nodejs,
  wasm-bindgen-cli_0_2_100,
  xz,
  removeReferencesTo,
  cef-binary,
  wayland,
  openssl,
  vulkan-loader,
  libGL,
  libxkbcommon,
  libxcursor,
  libx11,
  libxcb,
  nix-update-script,
}:

let
  version = "0-unstable-2026-03-13";
  rev = "eb30ee78bcf8971dc0098f07bdef1fef9d4a7e19";

  srcHash = "sha256-cQ6dLoFoNyiFFD/JVZ+U9kHrk2ZTcBxBCf8c3sMjCfQ=";
  shaderHash = "sha256-uc6FU0df5Xqp6YXEwODULhgUjSQvjRFGvdk+uFB7II0=";
  cargoHash = "sha256-GvKUZrrLYR2J4CnAbMs4TS6eOxSCq4AMecPGp6+008s=";
  npmHash = "sha256-r9jfk/fs6mL9L/7heelamOKzlCEu23UWId0kX35mOgE=";

  brandingRev = "8ae15dc9c51a3855475d8cab1d0f29d9d9bc622c";
  brandingHash = "sha256-mHdwHK2lEeFQWNrjbusvRULEmm03dP+0JM5bnUgHcF8=";

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
  cefPath = cef-binary.overrideAttrs (finalAttrs: {
    pname = "cef-path";
    postInstall = ''
      find $out -mindepth 1 -delete
      strip ./Release/*.so*
      mv ./Release/* $out/
      find "./Resources/locales" -maxdepth 1 -type f ! -name 'en-US.pak' -delete
      mv ./Resources/* $out/
      mv ./include $out/

      cat ./CREDITS.html | ${xz}/bin/xz -9 -e -c > $out/CREDITS.html.xz

      echo '${
        builtins.toJSON {
          type = "minimal";
          name = builtins.baseNameOf finalAttrs.src.url;
          sha1 = "";
        }
      }' > $out/archive.json
    '';
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "graphite";
  inherit version src;

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustc
    cargo
    lld
    pkg-config
    npmHooks.npmConfigHook
    binaryen
    wasm-bindgen-cli_0_2_100
    wasm-pack
    nodejs
    cargo-about
    removeReferencesTo
  ];

  buildInputs = libraries;

  cargoDeps = rustPlatform.fetchCargoVendor {
    src = finalAttrs.src;
    hash = cargoHash;
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) pname version;
    src = "${finalAttrs.src}/frontend";
    hash = npmHash;
  };
  npmRoot = "frontend";

  postPatch = ''
    mkdir branding
    cp -r ${branding}/* branding
    cp $src/.branding branding/.branding
  '';

  postConfigure = ''
    # Prevent `package-installer.js` from trying to update npm dependencies
    touch -r frontend/package-lock.json -d '+1 year' frontend/node_modules/.install-timestamp
  '';

  env.CEF_PATH = cefPath;
  env.RASTER_NODES_SHADER_PATH = shaders;
  env.GRAPHITE_GIT_COMMIT_HASH = finalAttrs.src.rev;

  buildPhase = ''
    runHook preBuild
    cargo run build desktop
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ./target/release/graphite $out/bin/

    mkdir -p $out/share/applications
    cp $src/desktop/assets/*.desktop $out/share/applications/

    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp ${branding}/app-icons/graphite.svg $out/share/icons/hicolor/scalable/apps/art.graphite.Graphite.svg

    runHook postInstall
  '';

  postFixup = ''
    patchelf \
      --set-rpath "${lib.makeLibraryPath libraries}:${cefPath}" \
      --add-needed libGL.so \
      $out/bin/graphite

    remove-references-to -t ${rustc} $out/bin/graphite
  '';

  disallowedReferences = [ rustc ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=branch"
      "--version-regex=(0-unstable-.*)"
    ];
  };

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
})
