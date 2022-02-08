{ lib
, mkDerivation
, fetchFromBitbucket
, makeDesktopItem
, copyDesktopItems
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

  # Fix darwin
  postPatch = ''
    substituteInPlace TIATracker.pro \
      --replace 'linux:' 'unix:'
  '';

  nativeBuildInputs = [
    qmake
    copyDesktopItems
  ];

  buildInputs = [
    qtbase
    SDL2
  ];

  desktopItems = [ desktopItem ];

  installPhase = ''
    runHook preInstall
    install -Dm755 TIATracker $out/bin/TIATracker
    install -Dm644 manual/tt_icon.png $out/share/icons/hicolor/256x256/tiatracker.png
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
