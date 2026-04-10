{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchzip,
  clickgen,
}:

stdenvNoCC.mkDerivation rec {
  pname = "bibata-cursors";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "ful1e5";
    repo = "Bibata_Cursor";
    rev = "v${version}";
    hash = "sha256-kIKidw1vditpuxO1gVuZeUPdWBzkiksO/q2R/+DUdEc=";
  };

  bitmaps = fetchzip {
    url = "https://github.com/ful1e5/Bibata_Cursor/releases/download/v${version}/bitmaps.zip";
    hash = "sha256-4VjyNWry0NPnt5+s0od/p18gry2O0ZrknYZh+PAPM8Q=";
  };

  nativeBuildInputs = [
    clickgen
  ];

  buildPhase = ''
    runHook preBuild

    ctgen configs/normal/x.build.toml -p x11 -d $bitmaps/Bibata-Modern-Amber -n 'Bibata-Modern-Amber' -c 'Yellowish and rounded edge Bibata XCursors'
    ctgen configs/normal/x.build.toml -p x11 -d $bitmaps/Bibata-Modern-Classic -n 'Bibata-Modern-Classic' -c 'Black and rounded edge Bibata XCursors'
    ctgen configs/normal/x.build.toml -p x11 -d $bitmaps/Bibata-Modern-Ice -n 'Bibata-Modern-Ice' -c 'White and rounded edge Bibata XCursors'

    ctgen configs/right/x.build.toml -p x11 -d $bitmaps/Bibata-Modern-Amber-Right -n 'Bibata-Modern-Amber-Right' -c 'Yellowish and rounded edge right-hand Bibata XCursors'
    ctgen configs/right/x.build.toml -p x11 -d $bitmaps/Bibata-Modern-Classic-Right -n 'Bibata-Modern-Classic-Right' -c 'Black and rounded edge right-hand Bibata XCursors'
    ctgen configs/right/x.build.toml -p x11 -d $bitmaps/Bibata-Modern-Ice-Right -n 'Bibata-Modern-Ice-Right' -c 'White and rounded edge right-hand Bibata XCursors'

    ctgen configs/normal/x.build.toml -p x11 -d $bitmaps/Bibata-Original-Amber -n 'Bibata-Original-Amber' -c 'Yellowish and sharp edge Bibata XCursors'
    ctgen configs/normal/x.build.toml -p x11 -d $bitmaps/Bibata-Original-Classic -n 'Bibata-Original-Classic' -c 'Black and sharp edge Bibata XCursors'
    ctgen configs/normal/x.build.toml -p x11 -d $bitmaps/Bibata-Original-Ice -n 'Bibata-Original-Ice' -c 'White and sharp edge Bibata XCursors'

    ctgen configs/right/x.build.toml -p x11 -d $bitmaps/Bibata-Original-Amber-Right -n 'Bibata-Original-Amber-Right' -c 'Yellowish and sharp edge right-hand Bibata XCursors'
    ctgen configs/right/x.build.toml -p x11 -d $bitmaps/Bibata-Original-Classic-Right -n 'Bibata-Original-Classic-Right' -c 'Black and sharp edge right-hand Bibata XCursors'
    ctgen configs/right/x.build.toml -p x11 -d $bitmaps/Bibata-Original-Ice-Right -n 'Bibata-Original-Ice-Right' -c 'White and sharp edge right-hand Bibata XCursors'

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -dm 0755 $out/share/icons
    cp -rf themes/* $out/share/icons/

    runHook postInstall
  '';

  meta = {
    description = "Material Based Cursor Theme";
    homepage = "https://github.com/ful1e5/Bibata_Cursor";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      rawkode
    ];
  };
}
