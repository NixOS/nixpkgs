{ lib, stdenv, fetchFromGitHub, fetchsvn
, scons, pkg-config, python3
, glib, libxml2, gtk2, libGLU, gnome2
, runCommand, writeScriptBin, runtimeShell
, makeDesktopItem, copyDesktopItems
}:

let
  q3Pack = fetchsvn {
    url = "svn://svn.icculus.org/gtkradiant-gamepacks/Q3Pack/trunk";
    rev = 144;
    sha256 = "sha256-U1GtMv775JEOAJ1W2kSaRNPDCnW39W+KqVDTTG2yISY=";
  };
  urtPack = fetchsvn {
    url = "svn://svn.icculus.org/gtkradiant-gamepacks/UrTPack/trunk";
    rev = 144;
    sha256 = "sha256-DQjENyQa1kEieU3ZWyMt2e4oEN0X2K3lxP79sBI91iI=";
  };
  etPack = fetchsvn {
    url = "svn://svn.icculus.org/gtkradiant-gamepacks/ETPack/trunk";
    rev = 144;
    sha256 = "sha256-mqaWOYfF/F6ABh7nKA36YvsywZIdwJ9IitFi2Xp5rgk=";
  };
  qlPack = fetchsvn {
    url = "svn://svn.icculus.org/gtkradiant-gamepacks/QLPack/trunk";
    rev = 144;
    sha256 = "sha256-lrn4nu3JI7j+t9jYd+UFE55GOCbc6+Sh2fZfVlEr1WM=";
  };
  q2Pack = fetchsvn {
    url = "svn://svn.icculus.org/gtkradiant-gamepacks/Q2Pack/trunk";
    rev = 144;
    sha256 = "sha256-ad8dRV+28Zz5yQsJU7hvteSIn9wWpehuqxMspw3yvvU=";
  };
  quetooPack = fetchsvn {
    url = "svn://svn.icculus.org/gtkradiant-gamepacks/QuetooPack/trunk";
    rev = 144;
    sha256 = "sha256-SOblPJgdVEZrTYtvDlcF7paIm3UitSVFQ9+RahXkO64=";
  };
  jaPack = fetchsvn {
    url = "svn://svn.icculus.org/gtkradiant-gamepacks/JAPack/trunk";
    rev = 144;
    sha256 = "sha256-P6lI+nNrPwoWJl5ThUHIA3Iw1nWVo2djaaWHAF5HuDo=";
  };
  stvefPack = fetchsvn {
    url = "svn://svn.icculus.org/gtkradiant-gamepacks/STVEFPack/trunk";
    rev = 144;
    sha256 = "sha256-quNyVC6fg1FIBsLWx0LzRK2JfxKMNJeUEIkWGhGJHhI=";
  };
  wolfPack = fetchsvn {
    url = "svn://svn.icculus.org/gtkradiant-gamepacks/WolfPack/trunk";
    rev = 144;
    sha256 = "sha256-693k6KiIchQddVGBhRJf7ikv6ut5L9rcLt0FTZ7pSvw=";
  };
  unvanquishedPack = fetchsvn {
    url = "https://github.com/Unvanquished/unvanquished-mapeditor-support.git/trunk/build/gtkradiant/";
    rev = 212;
    sha256 = "sha256-weBlnSBezPppbhsMOT66vubioTxpDC+AcKIOC2Xitdo=";
  };
  q1Pack = fetchsvn {
    url = "svn://svn.icculus.org/gtkradiant-gamepacks/Q1Pack/trunk";
    rev = 144;
    sha256 = "sha256-JfmDIUoDY7dYdMgwwUMgcwNhWxuxsdkv1taw8DXhPY4=";
  };
  packs = runCommand "gtkradiant-packs" {} ''
    mkdir -p $out
    ln -s ${q3Pack} $out/Q3Pack
    ln -s ${urtPack} $out/UrTPack
    ln -s ${etPack} $out/ETPack
    ln -s ${qlPack} $out/QLPack
    ln -s ${q2Pack} $out/Q2Pack
    ln -s ${quetooPack} $out/QuetooPack
    ln -s ${jaPack} $out/JAPack
    ln -s ${stvefPack} $out/STVEFPack
    ln -s ${wolfPack} $out/WolfPack
    ln -s ${unvanquishedPack} $out/UnvanquishedPack
    ln -s ${q1Pack} $out/Q1Pack
  '';

in
stdenv.mkDerivation rec {
  pname = "gtkradiant";

  version = "unstable-2022-07-31";

  src = fetchFromGitHub {
    owner = "TTimo";
    repo = "GtkRadiant";
    rev = "5b498bfa01bde6c2c9eb60fb94cf04666e52d22d";
    sha256 = "sha256-407faeQnhxqbWgOUunQKj2JhHeqIzPPgrhz2K5O4CaM=";
  };

  # patch paths so that .game settings are put into the user's home instead of the read-only /nix/store
  postPatch = ''
    substituteInPlace radiant/preferences.cpp \
      --replace 'gameFilePath += "games/";' 'gameFilePath = g_get_home_dir(); gameFilePath += "/.cache/radiant/games/";printf("gameFilePath: %s\\n", gameFilePath);' \
      --replace 'radCreateDirectory( gameFilePath );' 'if (g_mkdir_with_parents( gameFilePath, 0777 ) == -1) {radCreateDirectory( gameFilePath );};' \
      --replace 'strGamesPath = g_strAppPath.GetBuffer();' 'strGamesPath = g_get_home_dir();' \
      --replace 'strGamesPath += "games";' 'strGamesPath += "/.cache/radiant/games";'
  '';

  nativeBuildInputs =
    let
      python = python3.withPackages (ps: with ps; [
        urllib3
      ]);
      svn = writeScriptBin "svn" ''
        #!${runtimeShell} -e
        if [ "$1" = checkout ]; then
          # link predownloaded pack to destination
          mkdir -p $(dirname $3)
          ln -s ${packs}/$(basename $3) $3
          # verify existence
          test -e $(readlink $3)
        elif [ "$1" = update ]; then
          # verify existence
          test -e $(readlink $3)
        else
          echo "$@"
          exit 1
        fi
      '';
    in [
      scons
      pkg-config
      python
      svn
      copyDesktopItems
    ];

  buildInputs = [ glib libxml2 gtk2 libGLU gnome2.gtkglext ];

  enableParallelBuilding = true;

  desktopItems = [ (makeDesktopItem {
    name = "gtkradiant";
    exec = "gtkradiant";
    desktopName = "GtkRadiant";
    comment = meta.description;
    categories = [ "Development" ];
    icon = "gtkradiant";
    # includes its own splash screen
    startupNotify = false;
  }) ];

  postInstall = ''
    mkdir -p $out/{bin,lib}
    cp -ar install $out/lib/gtkradiant

    ln -s ../lib/gtkradiant/radiant.bin $out/bin/gtkradiant
    ln -s ../lib/gtkradiant/{q3map2,q3map2_urt,q3data} $out/bin/

    mkdir -p $out/share/pixmaps
    ln -s ../../lib/gtkradiant/bitmaps/icon.png $out/share/pixmaps/gtkradiant.png
  '';

  meta = with lib; {
    description = "Level editor for idTech games";
    homepage = "https://icculus.org/gtkradiant/";
    license = with licenses; [ gpl2Only bsdOriginal lgpl21Only ];
    maintainers = with maintainers; [ astro ];
    platforms = platforms.unix;
  };
}
