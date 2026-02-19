{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  pnpm,
  fetchPnpmDeps,
  pnpmConfigHook,
  wails,
  wrapGAppsHook3,
  glib-networking,
  makeDesktopItem,
  copyDesktopItems,
}:

buildGoModule rec {
  pname = "satisfactorymodmanager";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "satisfactorymodding";
    repo = "SatisfactoryModManager";
    tag = "v${version}";
    hash = "sha256-n1eGgvIxbWMugCaB/YX1chPgt97autDDJzomIgntz6M=";
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
    pnpm
    wails
    wrapGAppsHook3
    copyDesktopItems
  ];

  buildInputs = [
    glib-networking
  ];

  # we use env because buildGoModule doesn't forward all normal attrs
  # this is pretty hacky
  env = {
    pnpmDeps = fetchPnpmDeps {
      inherit
        pname
        version
        src
        ;
      sourceRoot = "${src.name}/frontend";
      fetcherVersion = 3;
      hash = "sha256-p0PFIqnIDZPffKaACWWDUvdBN+a0aMbZTUvz9wRTY+k=";
    };

    pnpmRoot = "frontend";
  };

  # running this caches some additional dependencies for the FOD
  overrideModAttrs = {
    preBuild = ''
      wails build -tags webkit2_41 # 4.0 EOL
    '';
  };

  proxyVendor = true;

  vendorHash = "sha256-LvDftUsmvrIY2WkC2pFxRasUGwytEE6ObhzDlrdgpB4=";

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
}
