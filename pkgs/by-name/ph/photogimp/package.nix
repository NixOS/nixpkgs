{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gimp,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "photogimp";
  version = "3.1";
  src = fetchFromGitHub {
    owner = "Diolinux";
    repo = "PhotoGIMP";
    tag = finalAttrs.version;
    hash = "sha256-524lsDRmahWXXP9/cfk2ia+7K6xNFTdoYXO8UUsLP/o=";
  };
  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];
  strictDeps = true;
  __structuredAttrs = true;

  dontBuild = true;

  postPatch = ''
    substituteInPlace .config/GIMP/3.0/theme.css \
      --replace-fail "file:///app/" "file://${gimp}/"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/photogimp
    cp -r .config/GIMP/3.0/. $out/share/photogimp/

    mkdir -p $out/share/icons
    cp -r .local/share/icons/. $out/share/icons/

    makeWrapper ${gimp}/bin/gimp $out/bin/photogimp \
      --run '
        PHOTOGIMP_DIR="''${XDG_CONFIG_HOME:-$HOME/.config}/PhotoGIMP/3.0"
        if [ ! -d "$PHOTOGIMP_DIR" ]; then
          mkdir -p "$PHOTOGIMP_DIR"
          cp -r --no-preserve=mode '"$out"'/share/photogimp/* "$PHOTOGIMP_DIR/"
          chmod -R +w "$PHOTOGIMP_DIR"
        fi
        export GIMP3_DIRECTORY="$PHOTOGIMP_DIR"
      '

    runHook postInstall
  '';
  desktopItems = [
    (makeDesktopItem {
      name = "photogimp";
      exec = "photogimp %U";
      icon = "photogimp";
      comment = "A patch for GIMP 3+ for Adobe Photoshop users";
      desktopName = "PhotoGIMP";
      genericName = "Image Editor";
      categories = [
        "Graphics"
        "2DGraphics"
        "RasterGraphics"
      ];
    })
  ];
  meta = {
    description = "A patch for GIMP 3+ for Adobe Photoshop users";
    homepage = "https://github.com/Diolinux/PhotoGIMP";
    license = lib.licenses.gpl3Only;
    mainProgram = "photogimp";
    maintainers = with lib.maintainers; [ Yonnix ];
    platforms = lib.platforms.linux;
  };
})
