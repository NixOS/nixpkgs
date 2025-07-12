{
  lib,
  zip,
  love,
  imagemagick,
  strip-nondeterminism,
  copyDesktopItems,
  fetchFromGitHub,
  makeDesktopItem,
  makeWrapper,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "honey-home";
  version = "0-unstable-2022-10-25";

  src =
    (fetchFromGitHub {
      owner = "dvdfu";
      repo = "ld38";
      rev = "45bb4bde8a667ee8cfb5034345bec90f70eb3b91";
      hash = "sha256-m8dyCoudTJDfP0KGcoA0Xj5LmRwN/8YOfEwiwCa8sOE=";
      fetchSubmodules = true;
    }).overrideAttrs
      (_: {
        GIT_CONFIG_COUNT = 1;
        GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
        GIT_CONFIG_VALUE_0 = "git@github.com:";
      });

  patches = [ ./fix-build.patch ];

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    imagemagick
    strip-nondeterminism
    zip
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "Honey Home";
      exec = "honey-home";
      icon = "honey-home";
      comment = "Save the bees in this tiny world";
      desktopName = "Honey Home";
      genericName = "Honey Home";
      categories = [ "Game" ];
    })
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/pixmaps
    # generate a logo as the title logo in the readme is too wide for an app icon
    magick \
      res/tree_hive.png \
      res/hud_bee.png -gravity Center -geometry -8+15 -composite \
      res/hud_bee.png -gravity Center -geometry -24+8 -composite \
      honey-home-logo.png
    install -Dm644 honey-home-logo.png $out/share/pixmaps/honey-home.png
    rm honey-home-logo.png
    zip -9 -r honey-home.love ./*
    strip-nondeterminism --type zip honey-home.love
    install -Dm444 -t $out/share/games/lovegames/ honey-home.love
    makeWrapper ${love}/bin/love $out/bin/honey-home \
      --add-flags $out/share/games/lovegames/honey-home.love
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/dvdfu/ld38";
    downloadPage = "https://dvdfu.itch.io/honey-home";
    description = "Honey Home, Ludum Dare 38 Jam winner";
    license = lib.licenses.unfreeRedistributable; # best guess as it is source available
    platforms = love.meta.platforms;
    mainProgram = "honey-home";
    maintainers = with lib.maintainers; [ phanirithvij ];
  };
})
