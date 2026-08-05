{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs_22,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  electron_41,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:
let
  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "picgo";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "Molunerfinn";
    repo = "PicGo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uxgrtuxcIlwCuz3X2hL0ZSpq8hMA4JxQD8ibNFw+35g=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) version src;
    inherit pnpm;
    pname = "picgo";
    hash = "sha256-a08WFoWcjo0mV1eu8oOQgbOiu/xfpoMxx3v17Eltsbk=";
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

  postBuild = ''
    cp -r src/renderer/public/. dist_electron/renderer/

    # Renderer assets are loaded from a file:// URL, so root-relative paths like
    # /squareLogo.png resolve to the filesystem root. Copy the renderer public assets
    # next to index.html and rewrite those references to relative paths.
    # https://github.com/Molunerfinn/PicGo/blob/dev/src/renderer/components/independent-window/mini/picgo-mini-page.tsx
    substituteInPlace dist_electron/renderer/assets/mini-*.js \
      --replace-fail '"/squareLogo.png"' '"./squareLogo.png"'
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
    # PicGo uses app.isPackaged to decide whether it is running in development mode.
    # With the nixpkgs Electron wrapper the executable is still the generic electron
    # binary, so app.isPackaged is false unless we force the packaged code path.
    # https://github.com/Molunerfinn/PicGo/blob/4d92ca199b7afead168785d7375a525ca156b25f/src/main/utils/env.ts#L17-L22

    # ELECTRON_FORCE_IS_PACKAGED makes PicGo use its production resource path,
    # but with the nixpkgs Electron wrapper process.resourcesPath points to Electron
    # itself, so point PicGo at the installed public assets
    makeWrapper ${lib.getExe electron_41} $out/bin/picgo \
      --add-flags "--class=picgo" \
      --add-flags "$out/lib/picgo/.launcher.cjs" \
      --set NODE_ENV production \
      --set ELECTRON_FORCE_IS_PACKAGED 1 \
      --set STATIC_PATH "$out/lib/picgo/public" \
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

  passthru.updateScript = nix-update-script { };

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
