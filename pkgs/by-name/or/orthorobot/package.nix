{
  lib,
  copyDesktopItems,
  fetchFromGitHub,
  fetchpatch,
  fetchurl,
  love,
  makeDesktopItem,
  makeWrapper,
  stdenv,
  strip-nondeterminism,
  zip,
}:

let
  icon = fetchurl {
    url = "https://stabyourself.net/images/screenshots/orthorobot-5.png";
    sha256 = "13fa4divdqz4vpdij1lcs5kf6w2c4jm3cc9q6bz5h7lkng31jzi6";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "orthorobot";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "Stabyourself";
    repo = "orthorobot";
    rev = "v${finalAttrs.version}";
    sha256 = "1ca6hvd890kxmamsmsfiqzw15ngsvb4lkihjb6kabgmss61a6s5p";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "orthorobot";
      exec = "orthorobot";
      icon = icon;
      comment = "A perspective based puzzle game, where you flatten the view to move across gaps";
      desktopName = "Orthorobot";
      genericName = "Perspective puzzle game";
      categories = [
        "Game"
        "LogicGame"
      ];
      singleMainWindow = true;
    })
  ];

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    strip-nondeterminism
    zip
  ];

  patches = [
    # support for love11
    # https://github.com/Stabyourself/orthorobot/pull/3
    (fetchpatch {
      name = "Stabyourself-orthorobot-pull-3.patch";
      url = "https://github.com/Stabyourself/orthorobot/compare/48f07423950b29a94b04aefe268f2f951f55b62e...05856ba7dbf1bb86d0f16a5f511d8ee9f2176015.patch";
      hash = "sha256-WHHP6QM7R5eEkVF+J2pGNnds/OKRIRXyon85wjd3GXI=";
    })
  ];

  buildPhase = ''
    runHook preBuild
    zip -9 -r orthorobot.love ./*
    strip-nondeterminism --type zip orthorobot.love
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm444 -t $out/share/games/lovegames/ orthorobot.love
    makeWrapper ${love}/bin/love $out/bin/orthorobot \
                --add-flags $out/share/games/lovegames/orthorobot.love
    runHook postInstall
  '';

  meta = {
    description = "Recharge the robot";
    mainProgram = "orthorobot";
    maintainers = with lib.maintainers; [ leenaars ];
    platforms = lib.platforms.linux;
    license = lib.licenses.wtfpl;
    downloadPage = "https://stabyourself.net/orthorobot/";
  };
})
