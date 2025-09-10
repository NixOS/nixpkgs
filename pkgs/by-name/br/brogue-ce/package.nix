{
  lib,
  stdenv,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,

  ncurses,
  SDL2,
  SDL2_image,

  terminal ? false,
  graphics ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "brogue-ce";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "tmewett";
    repo = "BrogueCE";
    rev = "v${finalAttrs.version}";
    hash = "sha256-habmfq1jZa70eggLOgsPT6j1OGmmQ6qmWcCwRN2G4Fo=";
  };

  postPatch = ''
    substituteInPlace linux/brogue-multiuser.sh \
      --replace broguedir= "broguedir=$out/opt/brogue-ce #"
  '';

  nativeBuildInputs = [
    copyDesktopItems
  ];

  buildInputs =
    (lib.optionals graphics [
      SDL2
      SDL2_image
    ])
    ++ (lib.optionals terminal [
      ncurses
    ]);

  makeFlags = [
    "DATADIR=$(out)/opt/brogue-ce"
    "TERMINAL=${if terminal then "YES" else "NO"}"
    "GRAPHICS=${if graphics then "YES" else "NO"}"
    "MAC_APP=${if stdenv.isDarwin then "YES" else "NO"}"
  ];

  postBuild = lib.optionalString (stdenv.isDarwin && graphics) ''
    make Brogue.app $makeFlags
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "brogue-ce";
      desktopName = "Brogue CE";
      genericName = "Roguelike";
      comment = "Brave the Dungeons of Doom!";
      icon = "brogue-ce";
      exec = "brogue-ce";
      categories = [
        "Game"
        "AdventureGame"
      ];
    })
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/opt
    cp -r bin $out/opt/brogue-ce
    install -Dm755 linux/brogue-multiuser.sh $out/bin/brogue-ce
    install -Dm 644 bin/assets/icon.png $out/share/icons/hicolor/256x256/apps/brogue-ce.png
    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenv.isDarwin && graphics) ''
    mkdir -p $out/Applications
    mv Brogue.app "$out/Applications/Brogue CE.app"
  '';

  meta = with lib; {
    description = "Community-lead fork of the minimalist roguelike game Brogue";
    mainProgram = "brogue-ce";
    homepage = "https://github.com/tmewett/BrogueCE";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [
      fgaz
    ];
    platforms = platforms.all;
  };
})
