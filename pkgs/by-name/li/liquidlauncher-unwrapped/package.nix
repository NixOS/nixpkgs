{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo-tauri,
  bun,
  nodejs,
  pkg-config,
  wrapGAppsHook3,
  writableTmpDirAsHomeHook,
  glib-networking,
  openssl,
  webkitgtk_4_1,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "liquidlauncher-unwrapped";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "CCBlueX";
    repo = "LiquidLauncher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hwNXrC3Zg0uOZiS124FSiv3X5EgB8d44vL9ypjQdt9k=";
  };

  node_modules = stdenv.mkDerivation {
    pname = "${finalAttrs.pname}-node_modules";
    inherit (finalAttrs) src version;

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;
    dontFixup = true;

    buildPhase = ''
      runHook preBuild

      bun install \
        --cpu="*" \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress \
        --os="*"

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r node_modules $out/node_modules

      runHook postInstall
    '';

    outputHash = "sha256-jjB2Sc5i6JLO2rtyoefrz3rd/zukO+2xlCi3p6cDFVc=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;
  cargoHash = "sha256-TGIue9NkgF2X7uDbrhrpyGag2vNdsjzOmLURzVS6Ghw=";

  __structuredAttrs = true;

  postPatch = ''
    cp -r ${finalAttrs.node_modules}/node_modules .
    chmod -R +w node_modules
    patchShebangs --build node_modules
  '';

  # Updater artifacts need upstream's signing key
  tauriBuildFlags = [
    "--config"
    ''{"bundle":{"createUpdaterArtifacts":false}}''
  ];

  nativeBuildInputs = [
    bun
    cargo-tauri.hook
    nodejs
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib-networking
    openssl
    webkitgtk_4_1
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "node_modules"
    ];
  };

  meta = {
    description = "Custom Minecraft launcher for LiquidBounce";
    homepage = "https://liquidbounce.net";
    changelog = "https://github.com/CCBlueX/LiquidLauncher/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ _1zun4 ];
    mainProgram = "liquidlauncher";
    platforms = [ "x86_64-linux" ];
  };
})
