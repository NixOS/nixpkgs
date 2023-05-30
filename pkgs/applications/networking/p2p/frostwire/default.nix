{ lib, stdenv, fetchFromGitHub, gradle_6, jre, makeWrapper, makeDesktopItem, mplayer }:

let
  version = "6.6.7-build-529";

  src = fetchFromGitHub {
    owner = "frostwire";
    repo = "frostwire";
    rev = "frostwire-desktop-${version}";
    sha256 = "03wdj2kr8akzx8m1scvg98132zbaxh81qjdsxn2645b3gahjwz0m";
  };

  desktopItem = makeDesktopItem {
    name = "frostwire";
    desktopName = "FrostWire";
    genericName = "P2P Bittorrent client";
    exec = "frostwire";
    icon = "frostwire";
    comment = "Search and explore all kinds of files on the Bittorrent network";
    categories = [ "Network" "FileTransfer" "P2P" ];
  };

  gradle = gradle_6;

in gradle.buildPackage {
  pname = "frostwire-desktop";
  inherit version src;

  nativeBuildInputs = [ makeWrapper ];
  gradleOpts.subdir = "desktop";
  gradleOpts.depsHash = "sha256-VomNnry/MwTwwQMU4Z4pi9q6118JgXTqMeD8bl7qncI=";
  gradleOpts.lockfileTree = ./lockfiles;
  preBuild = ''
    # disable auto-update (anyway it won't update frostwire installed in nix store)
    substituteInPlace src/com/frostwire/gui/updates/UpdateManager.java \
      --replace 'um.checkForUpdates' '// um.checkForUpdates'
    # fix path to mplayer
    substituteInPlace src/com/frostwire/gui/player/MediaPlayerLinux.java \
      --replace /usr/bin/mplayer ${mplayer}/bin/mplayer
  '';

  installPhase = ''
    mkdir -p $out/lib $out/share/java

    cp build/libs/frostwire.jar $out/share/java/frostwire.jar

    cp ${ { x86_64-darwin = "lib/native/*.dylib";
            x86_64-linux  = "lib/native/lib{jlibtorrent,SystemUtilities}.so";
            i686-linux    = "lib/native/lib{jlibtorrent,SystemUtilities}X86.so";
          }.${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}")
        } $out/lib

    cp -dpR ${desktopItem}/share $out

    makeWrapper ${jre}/bin/java $out/bin/frostwire \
      --add-flags "-Djava.library.path=$out/lib -jar $out/share/java/frostwire.jar"
  '';

  meta = with lib; {
    homepage = "https://www.frostwire.com/";
    description = "BitTorrent Client and Cloud File Downloader";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # deps
    ];
    license = licenses.gpl2;
    maintainers = with maintainers; [ gavin ];
    platforms = [ "x86_64-darwin" "x86_64-linux" "i686-linux" ];
  };
}
