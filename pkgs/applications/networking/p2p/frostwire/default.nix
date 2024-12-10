{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle_6,
  perl,
  jre,
  makeWrapper,
  makeDesktopItem,
  mplayer,
}:

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
    categories = [
      "Network"
      "FileTransfer"
      "P2P"
    ];
  };

  # fake build to pre-download deps into fixed-output derivation
  deps = stdenv.mkDerivation {
    pname = "frostwire-desktop-deps";
    inherit version src;
    buildInputs = [
      gradle_6
      perl
    ];
    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d)
      ( cd desktop
        gradle --no-daemon build
      )
    '';
    # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    installPhase = ''
      find $GRADLE_USER_HOME -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
    '';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-r6YSrbSJbM3063JrX4tCVKFrJxTaLN4Trc+33jzpwcE=";
  };

in
stdenv.mkDerivation {
  pname = "frostwire-desktop";
  inherit version src;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ gradle_6 ];

  buildPhase = ''
    export GRADLE_USER_HOME=$(mktemp -d)
    ( cd desktop

      # disable auto-update (anyway it won't update frostwire installed in nix store)
      substituteInPlace src/com/frostwire/gui/updates/UpdateManager.java \
        --replace 'um.checkForUpdates' '// um.checkForUpdates'

      # fix path to mplayer
      substituteInPlace src/com/frostwire/gui/player/MediaPlayerLinux.java \
        --replace /usr/bin/mplayer ${mplayer}/bin/mplayer

      substituteInPlace build.gradle \
        --replace 'mavenCentral()' 'mavenLocal(); maven { url uri("${deps}") }'
      gradle --offline --no-daemon build
    )
  '';

  installPhase = ''
    mkdir -p $out/lib $out/share/java

    cp desktop/build/libs/frostwire.jar $out/share/java/frostwire.jar

    cp ${
      {
        x86_64-darwin = "desktop/lib/native/*.dylib";
        x86_64-linux = "desktop/lib/native/lib{jlibtorrent,SystemUtilities}.so";
        i686-linux = "desktop/lib/native/lib{jlibtorrent,SystemUtilities}X86.so";
      }
      .${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}")
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
      binaryBytecode # deps
    ];
    license = licenses.gpl2;
    maintainers = with maintainers; [ gavin ];
    platforms = [
      "x86_64-darwin"
      "x86_64-linux"
      "i686-linux"
    ];
    broken = true; # at 2022-09-30, errors with changing hash.
  };
}
