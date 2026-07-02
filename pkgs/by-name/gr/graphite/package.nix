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
}:

let
  version = "0-unstable-2026-05-02";
  rev = "ab7f59ca61004a1b11f9ae4b1c511cefc7a0f404";

  srcHash = "sha256-DV3/1dgtUiTmGkOm4z3GVJcWzvCjO/crzc/l8ovW0XA=";
  shaderHash = "sha256-76hOCx1fpFBI5nVmIAIGd2StCRzhbCgs+GHMvxbflLc=";
  cargoHash = "sha256-ZesLyXKjz2CSrAWUT5Hq6w97pR55I+C79qPwF0dqXXI=";
  npmHash = "sha256-AX5Jqk2E+WyQJyHbgvvq74MRsYmWUju4bOkabhYoeig=";

  brandingRev = "1939ca82f3341427059e15bfa205f7c22aaf867a";
  brandingHash = "sha256-SDnCpLuppHVE7cUVidevH2O/2ma0S2tuQDhFkS/JLvA=";

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

    substituteInPlace $cargoDepsCopy/*/cef-dll-sys-*/build.rs \
      --replace-fail \
        'download_cef::check_archive_json(&package_version, &path.to_string_lossy())?;' \
        ""
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
      --add-needed libEGL.so \
      $out/bin/graphite

    remove-references-to -t ${rustc} $out/bin/graphite
  '';

  disallowedReferences = [ rustc ];

  passthru.updateScript = ./update.nu;

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
