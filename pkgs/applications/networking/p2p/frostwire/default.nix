{ stdenv, lib, fetchFromGitHub, gradle, perl, jre, makeWrapper, makeDesktopItem, mplayer }:

let
  version = "6.6.3-build-253";
  name = "frostwire-desktop-${version}";

  src = fetchFromGitHub {
    owner = "frostwire";
    repo = "frostwire";
    rev = name;
    sha256 = "1bqv942hfz12i3b3nm1pfwdp7f58nzjxg44h31f3q47719hh8kd7";
  };

  desktopItem = makeDesktopItem {
    name = "frostwire";
    desktopName = "FrostWire";
    genericName = "P2P Bittorrent client";
    exec = "frostwire";
    icon = "frostwire";
    comment = "Search and explore all kinds of files on the Bittorrent network";
    categories = "Network;FileTransfer;P2P;";
  };

  # fake build to pre-download deps into fixed-output derivation
  deps = stdenv.mkDerivation {
    name = "${name}-deps";
    inherit src;
    buildInputs = [ gradle perl ];
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
    outputHash = "0p279i41q7pn6nss8vndv3g4qzrvj3pmhdxq50kymwkyp2kly3lc";
  };

in stdenv.mkDerivation {
  inherit name src;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ gradle ];

  buildPhase = ''
    export GRADLE_USER_HOME=$(mktemp -d)
    ( cd desktop
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

    cp ${ { x86_64-darwin = "desktop/lib/native/*.dylib";
            x86_64-linux  = "desktop/lib/native/libjlibtorrent.so";
            i686-linux    = "desktop/lib/native/libjlibtorrentx86.so";
          }.${stdenv.system} or (throw "unsupported system ${stdenv.system}")
        } $out/lib

    cp -dpR ${desktopItem}/share $out

    makeWrapper ${jre}/bin/java $out/bin/frostwire \
      --add-flags "-Djava.library.path=$out/lib -jar $out/share/java/frostwire.jar"
  '';

  meta = with stdenv.lib; {
    homepage = http://www.frostwire.com/;
    description = "BitTorrent Client and Cloud File Downloader";
    license = licenses.gpl2;
    maintainers = with maintainers; [ gavin ];
    platforms = [ "x86_64-darwin" "x86_64-linux" "i686-linux" ];
  };
}
