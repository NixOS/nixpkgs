{ stdenv
, lib
, mkDerivation
, fetchFromBitbucket
, makeDesktopItem
, copyDesktopItems
, libicns
, qmake
, qtbase
, SDL2
}:

let
  description = "Music tracker for making Atari VCS 2600 music";
  desktopItem = makeDesktopItem {
    name = "TIATracker";
    desktopName = "TIATracker";
    comment = description;
    exec = "TIATracker";
    icon = "tiatracker";
    type = "Application";
    categories = "AudioVideo;AudioVideoEditing;";
    extraEntries = "Keywords=tracker;music;";
  };

in mkDerivation rec {
  pname = "tiatracker";
  version = "1.3";

  src = fetchFromBitbucket {
    owner = "kylearan";
    repo = "tiatracker";
    rev = "ca0bb54ef67d2614f7a0fd70a3c912782d673af3";
    sha256 = "sha256-koQJTCqJD12KRdtE9C17f9qTyyRyHebnrpSwyZyO8wo=";
  };

  postPatch = ''
    # Fix SDL2 linking on Darwin, doesn't break Linux
    substituteInPlace TIATracker.pro \
      --replace 'linux:' 'unix:'
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    png2icns graphics/tt_icon.{icns,png}
    substituteInPlace TIATracker.pro \
      --replace 'RC_ICONS = graphics/tt_icon.ico' 'ICON = graphics/tt_icon.icns'
  '';

  nativeBuildInputs = [
    qmake
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    copyDesktopItems
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libicns
  ];

  buildInputs = [
    qtbase
    SDL2
  ];

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [ desktopItem ];

  installPhase = ''
    runHook preInstall
  '' + (if stdenv.hostPlatform.isDarwin then ''
    mkdir -p $out/{Applications,bin}
    mv TIATracker.app $out/Applications/
    ln -s $out/{Applications/TIATracker.app/Contents/MacOS,bin}/TIATracker
  '' else ''
    install -Dm755 TIATracker $out/bin/TIATracker
    install -Dm644 manual/tt_icon.png $out/share/icons/hicolor/256x256/tiatracker.png
  '') + ''
    install -Dm644 data/keymap.cfg $out/share/tiatracker/keymap.cfg.sample
    cp -r songs $out/share/tiatracker/songs
    install -Dm644 data/TIATracker_manual.pdf $out/share/doc/tiatracker/TIATracker_manual.pdf
    runHook postInstall
  '';

  meta = with lib; {
    inherit description;
    inherit (src.meta) homepage;
    license = with licenses; [ gpl2Only asl20 ];
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}
