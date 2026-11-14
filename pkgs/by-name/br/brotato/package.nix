{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  godot3,
  libicns,
  copyDesktopItems,
  makeDesktopItem,
  requireFile,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "brotato";
  version = "1.1.13.2";

  src = requireFile {
    name = "Brotato.pck";
    url = "https://store.epicgames.com/en-US/p/brotato-ed4097";
    hash = "sha256-/k/rnypHS3Gtj5nHb1cnx1JvCiJAKe+1JxlXolWksS0=";
  };

  srcIcon = fetchurl {
    name = "brotato.icns";
    url = "https://shared.fastly.steamstatic.com/community_assets/images/apps/1942280/c096e6b30bcb9749183fe5d1b78f77de7ae89383.icns";
    hash = "sha256-6ZZ1kqdOjqwIByrX1Bqrhy2yMaShlsbsEhuDBTK77gw=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
    godot3
    libicns
    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin

    makeWrapper ${lib.getExe godot3} $out/bin/brotato \
      --add-flags "--main-pack $src"

    cp $srcIcon brotato.icns
    icns2png -x brotato.icns
    mkdir -p $out/share/icons/hicolor/512x512/apps
    install -Dm644 brotato_512x512x32.png $out/share/icons/hicolor/512x512/apps/brotato.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "brotato";
      desktopName = "Brotato";
      exec = "brotato";
      icon = "brotato";
      comment = finalAttrs.meta.description;
      categories = [
        "Game"
        "ActionGame"
        "Shooter"
      ];
      terminal = false;
    })
  ];

  meta = {
    description = "Only potato capable of handling 6 weapons at the same time";
    homepage = "https://www.blobfishgames.com/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ appsforartists ];
    platforms = lib.platforms.linux;
    mainProgram = "brotato";
  };
})
