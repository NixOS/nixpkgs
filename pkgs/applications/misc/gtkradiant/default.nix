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
  darkPlacesPack = fetchsvn {
    url = "svn://svn.icculus.org/gtkradiant-gamepacks/DarkPlacesPack/trunk";
    rev = 57;
    sha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";
  };
  doom3Pack = fetchsvn {
    url = "svn://svn.icculus.org/gtkradiant-gamepacks/Doom3Pack/trunk";
    rev = 56;
    sha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";
  };
  halfLifePack = fetchsvn {
    url = "svn://svn.icculus.org/gtkradiant-gamepacks/HalfLifePack/trunk";
    rev = 1;
    sha256 = "sha256-CrbN3iOG89j71y4ZJ4gNZEA5CYxphLLGbZwv6Tbjui0=";
  };
  her2Pack = fetchsvn {
    url = "svn://svn.icculus.org/gtkradiant-gamepacks/Her2Pack/trunk";
    rev = 55;
    sha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";
  };
  jk2Pack = fetchsvn {
    url = "svn://svn.icculus.org/gtkradiant-gamepacks/JK2Pack/trunk";
    rev = 77;
    sha256 = "sha256-3g/p9OC0j2va9CXXtsQf0lP6VJ1WyI5k2W9xNRwYjS8=";
  };
  nexuizPack = fetchsvn {
    url = "svn://svn.icculus.org/gtkradiant-gamepacks/NexuizPack/trunk";
    rev = 49;
    sha256 = "sha256-nAV7rZKDgAxlEmu2RfBFNsHv9Xgas1IlDgioligvY+c=";
  };
  preyPack = fetchsvn {
    url = "svn://svn.icculus.org/gtkradiant-gamepacks/PreyPack/trunk";
    rev = 19;
    sha256 = "sha256-wbKEnSaFO40HxhMsbYKy76MxXDvY9O1lTcr3M7fXxW0=";
  };
  q2wPack = fetchsvn {
    url = "svn://svn.icculus.org/gtkradiant-gamepacks/Q2WPack/trunk";
    rev = 126;
    sha256 = "sha256-Q6IyL2qUr+6ktP34oYkFqN5MeFxCXOkcjrPg5J95ftg=";
  };
  q4Pack = fetchsvn {
    url = "svn://svn.icculus.org/gtkradiant-gamepacks/Q4Pack/trunk";
    rev = 54;
    sha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";
  };
  ravenPack = fetchsvn {
    url = "svn://svn.icculus.org/gtkradiant-gamepacks/RavenPack/trunk";
    rev = 1;
    sha256 = "sha256-bYRjCkdaznaO7+WDB6cgL3szTB+MXwt3IKH3L2rGjLs=";
  };
  reactionPack = fetchsvn {
    url = "svn://svn.icculus.org/gtkradiant-gamepacks/ReactionPack/trunk";
    rev = 69;
    sha256 = "sha256-aXSM0ubyhgamLBzfNZ6RzRSdzKwfHWLt/6OS/i9mMVo=";
  };
  sof2Pack = fetchsvn {
    url = "svn://svn.icculus.org/gtkradiant-gamepacks/Sof2Pack/trunk";
    rev = 1;
    sha256 = "sha256-EnGhYghXe6hU5vvdF+Z9geTiHDukBEr1+CQgunxxGic=";
  };
  tremulousPack = fetchsvn {
    url = "svn://svn.icculus.org/gtkradiant-gamepacks/TremulousPack/trunk";
    rev = 46;
    sha256 = "sha256-NU+ynpqydFxdZSkh7Szm6DTqyMYVS+PU70Mp98ZjdOs=";
  };
  ufoaiPack = fetchsvn {
    url = "svn://svn.icculus.org/gtkradiant-gamepacks/UFOAIPack/trunk";
    rev = 69;
    sha256 = "sha256-nAd7fFZJJ82rDPVlTiZkkTGXi5tw7BSKk+akFBXSWvY=";
  };
  warsowPack = fetchsvn {
    url = "svn://svn.icculus.org/gtkradiant-gamepacks/WarsowPack/trunk";
    rev = 53;
    sha256 = "sha256-IQ12fEKnq0cJxef+ddvTXcwM8lQ8nlUoMJy81XJ7ANY=";
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
    ln -s ${darkPlacesPack} $out/DarkPlacesPack
    ln -s ${doom3Pack} $out/Doom3Pack
    ln -s ${halfLifePack} $out/HalfLifePack
    ln -s ${her2Pack} $out/Her2Pack
    ln -s ${jk2Pack} $out/JK2Pack
    ln -s ${nexuizPack} $out/NexuizPack
    ln -s ${preyPack} $out/PreyPack
    ln -s ${q2wPack} $out/Q2WPack
    ln -s ${q4Pack} $out/Q4Pack
    ln -s ${ravenPack} $out/RavenPack
    ln -s ${reactionPack} $out/ReactionPack
    ln -s ${sof2Pack} $out/Sof2Pack
    ln -s ${tremulousPack} $out/TermulousPack
    ln -s ${ufoaiPack} $out/UFOAIPack
    ln -s ${warsowPack} $out/WarsowPack
  '';

in
stdenv.mkDerivation rec {
  pname = "gtkradiant";

  version = "unstable-2023-04-24";

  src = fetchFromGitHub {
    owner = "TTimo";
    repo = "GtkRadiant";
    rev = "ddbaf03d723a633d53fa442c2f802f7ad164dd6c";
    sha256 = "sha256-qI+KGx73AbM5PLFR2JDXKDbiqmU0gS/43rhjRKm/Gms=";
  };

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
          test -e $(readlink $2)
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
    for pack in ${packs}/* ; do
      name=$(basename "$pack")
      if ! [ -e $out/lib/gtkradiant/installs/$name ]; then
        ln -s $pack $out/lib/gtkradiant/installs/$name
      fi
    done

    cat >$out/bin/gtkradiant <<EOF
    #!${runtimeShell} -e
    export XDG_DATA_HOME="\''${XDG_DATA_HOME:-\$HOME/.local/share}"
    exec "$out/lib/gtkradiant/radiant.bin" "\$@"
    EOF
    chmod +x $out/bin/gtkradiant
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
