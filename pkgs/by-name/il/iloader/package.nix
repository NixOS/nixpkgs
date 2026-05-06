{
  lib,
  stdenv,
  fetchFromGitHub,

  rustPlatform,
  nodejs,
  cargo-tauri,
  bun,
  writableTmpDirAsHomeHook,

  glib,
  glib-networking,
  gst_all_1,
  openssl,
  pkg-config,
  webkitgtk_4_1,
  wrapGAppsHook3,
  makeWrapper,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "iloader";
  version = "2.2.4";

  src = fetchFromGitHub {
    owner = "nab138";
    repo = "iloader";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-cKUyxNsnqG1GSD+zMNjIoOkl4+IHRfWLQQo8IDjIS/o=";
  };

  nodeModules = stdenv.mkDerivation {
    pname = "${finalAttrs.pname}-node_modules";
    inherit (finalAttrs) src version;

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;

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

    outputHash = "sha256-zB0BJrQuoIu7Y67WMfrVRsPPnJ6mhd5srL2M3zW6+1Q=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = "src-tauri";
  cargoHash = "sha256-ryXbUBNtMjZcQGivnjqRBxbGsW6UAJbU38rTqzwvH+Y=";

  doCheck = false;

  patches = [ ./disable-update.patch ];

  postPatch = ''
    cp -r ${finalAttrs.nodeModules}/node_modules .
    chmod -R +w node_modules
    patchShebangs --build node_modules
  '';

  nativeBuildInputs = [
    bun
    cargo-tauri.hook
    nodejs
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook3 ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ makeWrapper ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    webkitgtk_4_1
    glib
    glib-networking
    openssl
  ];

  tauriBuildFlags = [
    "--config"
    "ci.conf.json"
    "--no-sign"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/bin
    makeWrapper $out/Applications/iloader.app/Contents/MacOS/iloader $out/bin/iloader
  '';

  meta = {
    changelog = "https://github.com/nab138/iloader/releases/tag/v${finalAttrs.version}";
    description = "User friendly sideloader";
    homepage = "https://github.com/nab138/iloader";
    license = lib.licenses.mit;
    mainProgram = "iloader";
    maintainers = with lib.maintainers; [ ern775 ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  };
})
