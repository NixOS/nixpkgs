{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nodejs_20,
  pnpm_8,
  fetchPnpmDeps,
  pnpmConfigHook,
  wails,
  wrapGAppsHook3,
  glib-networking,
  makeDesktopItem,
  copyDesktopItems,
}:

let
  # NodeJS 22.18.0 broke our build, not sure why
  wails' = wails.override { nodejs = nodejs_20; };
  pnpm' = pnpm_8.override { nodejs = nodejs_20; };
in
buildGoModule (finalAttrs: {
  pname = "satisfactorymodmanager";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "satisfactorymodding";
    repo = "SatisfactoryModManager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ndvrgSRblm7pVwnGvxpwtGVMEGp+mqpC4kE87lmt36M=";
  };

  patches = [
    # disable postcss-import-url
    ./dont-vendor-remote-fonts.patch

    # populates the lib/generated directory
    ./add-generated-files.patch
  ];

  postPatch = ''
    # don't generate i18n and graphql code
    substituteInPlace frontend/package.json \
        --replace-fail '"postinstall":' '"_postinstall":'
  '';

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm'
    wails'
    wrapGAppsHook3
    copyDesktopItems
  ];

  buildInputs = [
    glib-networking
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    pnpm = pnpm';
    sourceRoot = "${finalAttrs.src.name}/frontend";
    fetcherVersion = 3;
    hash = "sha256-aicvZ/pmBZNcy/MqH/C12llKnoDm9ahH7egJZh5mIGM=";
  };

  pnpmRoot = "frontend";

  # running this caches some additional dependencies for the FOD
  overrideModAttrs = {
    preBuild = ''
      wails build -tags webkit2_41 # 4.0 EOL
    '';
  };

  proxyVendor = true;

  vendorHash = "sha256-3nsJPuwL2Zw/yuHvd8rMSpj9DBBpYUaR19z9TSV/7jg=";

  buildPhase = ''
    runHook preBuild
    wails build -tags webkit2_41 # 4.0 EOL
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 build/bin/SatisfactoryModManager -t "$out/bin"

    for i in 16 32 64 128 256 512; do
      install -D ./icons/"$i"x"$i".png "$out"/share/icons/hicolor/"$i"x"$i"/apps/SatisfactoryModManager.png
    done
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "SatisfactoryModManager";
      desktopName = "Satisfactory Mod Manager";
      exec = "SatisfactoryModManager %u";
      mimeTypes = [ "x-scheme-handler/smmanager" ];
      icon = "SatisfactoryModManager";
      terminal = false;
      categories = [ "Game" ];
    })
  ];

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Mod manager and modloader for Satisfactory";
    homepage = "https://github.com/satisfactorymodding/SatisfactoryModManager";
    license = lib.licenses.gpl3Only;
    mainProgram = "SatisfactoryModManager";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
