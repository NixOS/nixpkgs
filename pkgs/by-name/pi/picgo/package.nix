{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs_22,
  pnpm,
  fetchPnpmDeps,
  pnpmConfigHook,
  electron_38,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "picgo";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "Molunerfinn";
    repo = "PicGo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M3cA17DoPXfldvq1vjF3P9HEXGkd+TXFuTr95iqIWsQ=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) version src;
    pname = "picgo";
    hash = "sha256-BfKTZy9NBfBj0MwREoxYmyvhfXP4FlADam2SwNTOJ2U=";
    fetcherVersion = 3; # lockfileVersion 9.0 corresponds to fetcherVersion 3
  };

  nativeBuildInputs = [
    nodejs_22
    pnpm
    pnpmConfigHook
    makeWrapper
    copyDesktopItems
    writableTmpDirAsHomeHook
  ];

  env = {
    NODE_ENV = "development";
  };

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Create application directory
    mkdir -p $out/lib/picgo

    # Copy build outputs
    cp -r dist_electron $out/lib/picgo/
    cp -r public $out/lib/picgo/
    cp package.json $out/lib/picgo/
    cp -r node_modules $out/lib/picgo/

    # Create launcher script to set application name
    cp ${./launcher.cjs} $out/lib/picgo/.launcher.cjs

    # Create startup script
    mkdir -p $out/bin
    makeWrapper ${lib.getExe electron_38} $out/bin/picgo \
      --add-flags "$out/lib/picgo/.launcher.cjs" \
      --add-flags "--name picgo" \
      --set NODE_ENV production \
      --set-default ELECTRON_OZONE_PLATFORM_HINT auto \
      --chdir "$out/lib/picgo"

    # Install icons
    for size in 256x256 512x512; do
      if [ -f "build/icons/$size.png" ]; then
        mkdir -p $out/share/icons/hicolor/$size/apps
        cp "build/icons/$size.png" $out/share/icons/hicolor/$size/apps/picgo.png
      fi
    done

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "picgo";
      desktopName = "PicGo";
      genericName = "Picture Uploader";
      comment = "A simple & beautiful tool for pictures uploading";
      exec = "picgo %U";
      icon = "picgo";
      categories = [
        "Utility"
        "Graphics"
      ];
      mimeTypes = [ "x-scheme-handler/picgo" ];
      startupWMClass = "picgo";
    })
  ];

  meta = {
    description = "Simple tool for uploading pictures";
    longDescription = ''
      PicGo is a simple & beautiful tool for uploading pictures built by `electron-vue`.
      It supports uploading images to various cloud storage services and clipboard management.
      The application features a plugin system for extending functionality.
    '';
    homepage = "https://picgo.app";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "picgo";
    maintainers = with lib.maintainers; [ qrzbing ];
  };
})
