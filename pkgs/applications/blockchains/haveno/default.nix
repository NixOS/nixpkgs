{ stdenv
, lib
, makeWrapper
, fetchurl
, fetchFromGitHub
, makeDesktopItem
, copyDesktopItems
, imagemagick
, openjdk21
, gradle
, gnumake
, protobuf
, writeScript
, bash
, stripJavaArchivesHook
, tor
, zip
, xz
, findutils
, perl
}:

stdenv.mkDerivation rec {
  pname = "haveno";
  version = "1.0.3-281b7d0";

  src = fetchFromGitHub {
    owner = "haveno-dex";
    repo = "haveno";
    rev = "281b7d0905a0272d8c202c6776191642172843c7";
    hash = "sha256-uDJhmK7Jr6BTe6bYY7pp19zhymnXJXtTuQ1jkzyRQ8E=";
  };

  nativeBuildInputs = [ gradle makeWrapper ];

  # TODO(Krey)
  # desktopItems = [
  #   (makeDesktopItem {
  #     name = "Bisq";
  #     exec = "bisq-desktop";
  #     icon = "bisq";
  #     desktopName = "Bisq ${version}";
  #     genericName = "Decentralized bitcoin exchange";
  #     categories = [ "Network" "P2P" ];
  #   })
  # ];

  # fake build to pre-download deps into fixed-output derivation
  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit src version;
    nativeBuildInputs = [ gradle perl ];
    buildPhase = ''
      export GRADLE_USER_HOME="$(mktemp -d)"
      gradle --no-daemon build
    '';
    # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/''${\($5 =~ s/okio-jvm/okio/r)}" #e' \
        | sh
    '';
    # Don't move info to share/
    forceShare = [ "dummy" ];
    outputHashMode = "recursive";
    # Downloaded jars differ by platform
    # outputHash = "sha256-cs95YI0SpvzCo5x5trMXlVUGepNKIH9oZ95AfLErKIU=";
    outputHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  preBuild = ''
    # Use the local packages from deps
    sed -i -e '/repositories {/a maven { url uri("${deps}") }' build.gradle
    mkdir -p .localnet
  '';

  buildPhase = ''
    gradle --offline --no-daemon build
  '';

  installPhase = ''
    runHook preInstall

    # "haveno-apitest" "haveno-cli" "haveno-daemon" "haveno-desktop" "haveno-inventory" "haveno-monitor" "haveno-relay" "haveno-seednode" "haveno-statsnode"

    # ...

    runHook postInstall
  '';

  # passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "A decentralized bitcoin exchange network";
    homepage = "https://bisq.network";
    license = licenses.mit;
    maintainers = with maintainers; [ juaningan emmanuelrosa ];
    platforms = [ "x86_64-linux" ];
  };
}
