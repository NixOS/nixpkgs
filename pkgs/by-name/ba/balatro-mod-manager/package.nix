{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  glib,
  gtk3,
  webkitgtk_4_1,
  bun,
  cargo-tauri,
  writableTmpDirAsHomeHook,
  nodejs,
  wrapGAppsHook4,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "balatro-mod-manager";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "skyline69";
    repo = "balatro-mod-manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ISEgmyGA96r+OolKc/8qiKee43ruNonmWdqfM4pr3p8=";
  };

  nodeModules = stdenv.mkDerivation {
    pname = "${finalAttrs.pname}-node_modules";
    inherit (finalAttrs) version src;

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild
      bun install --frozen-lockfile --allow-scripts --no-progress
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r node_modules $out/node_modules
      runHook postInstall
    '';

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-97O4DrnjZO2mhSrCQz9xbcRCSaxMNNa4NaLNPlmecJg=";
  };

  cargoHash = "sha256-TPZf4jtv/3mIpe6ASzPkIusQC/iPFpYN51XiiH6pkZc=";

  dontUseCargoParallelTests = true;
  checkFlags = [
    # skip tests that depend on networking
    "--skip paging_stops_when_cursor_is_none"
    "--skip apply_changed_updates_and_deletes"
    # skip tests that looks for CA certificates
    "--skip test_is_installed_with_no_dir"
    "--skip test_mod_installer_new"
  ];

  nativeBuildInputs = [
    pkg-config
    cargo-tauri.hook
    bun
    wrapGAppsHook4
    nodejs
  ];

  buildInputs = [
    glib
    gtk3
    webkitgtk_4_1
  ];

  postPatch = ''
    cp -r ${finalAttrs.nodeModules}/node_modules .
    chmod -R +w node_modules
    patchShebangs --build node_modules
  '';

  postInstall = ''
    for size in 32 128 512; do
      install -Dm644 src-tauri/icons/"$size"x"$size".png $out/share/icons/hicolor/"$size"x"$size"/apps/balatro-mod-manager.png
    done
  '';

  meta = {
    description = "A mod manager for the game Balatro";
    homepage = "https://balatro-mod-manager.dasguney.com/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ mhdask ];
    mainProgram = "BMM";
  };
})
