{
  lib,
  stdenv,
  fetchFromGitHub,
  love,
  lua,
  zip,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  tmx2lua,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hawkthorne-journey";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "hawkthorne";
    repo = "hawkthorne-journey";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RhxI2ChkFCBu2FaW2/eHT1KTTjKP++aHDktT+qQ5ooQ=";
  };

  nativeBuildInputs = [
    zip
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    love
    lua
    tmx2lua
  ];

  buildPhase = ''
    runHook preBuild

    # Convert TMX maps to Lua
    for tmxfile in src/maps/*.tmx; do
      tmx2lua "$tmxfile"
    done

    # Create the .love file
    cd src
    zip -X -r ../hawkthorne.love . \
      -x ".*" \
      -x "*.DS_Store" \
      -x "psds/*" \
      -x "test/*" \
      -x "*.tmx" \
      -x "maps/test-level.lua" \
      -x "*/full_soundtrack.ogg" \
      -x "*.bak"

      runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cd ..
    mkdir -p $out/share/games/hawkthorne
    cp hawkthorne.love $out/share/games/hawkthorne/

    mkdir -p $out/bin
    makeWrapper ${love}/bin/love $out/bin/hawkthorne \
      --add-flags "$out/share/games/hawkthorne/hawkthorne.love"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "hawkthorne";
      exec = "hawkthorne";
      icon = "hawkthorne";
      desktopName = "Journey to the Center of Hawkthorne";
      genericName = "Platform Game";
      categories = [
        "Game"
        "ArcadeGame"
      ];
    })
  ];

  meta = {
    description = "Journey to the Center of Hawkthorne - Community Fan Game";
    homepage = "https://projecthawkthorne.com";
    changelog = "https://github.com/hawkthorne/hawkthorne-journey/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "hawkthorne";
  };
})
