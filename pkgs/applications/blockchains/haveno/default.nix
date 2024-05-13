{ stdenv
, lib
, makeWrapper
, fetchurl
, fetchFromGitHub
, makeDesktopItem
, copyDesktopItems
, imagemagick
, openjdk11
, dpkg
, gradle
, gnumake
, jdk21
, writeScript
, bash
, stripJavaArchivesHook
, tor
, zip
, xz
, findutils
}:

stdenv.mkDerivation rec {
  pname = "haveno";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "haveno-dex";
    repo = "haveno";
    rev = "cc247bbc69994b3904f6e7237c4f1c6835a9e33e";
    hash = "sha256-ptjrZ3dLPRtAUIHWBnXP7OTwWmN+4OylJwPimJotwW8=";
  };

  nativeBuildInputs = [
    gnumake
    jdk21
    gradle

    copyDesktopItems

    imagemagick
    makeWrapper
    stripJavaArchivesHook
    xz
    zip
    findutils
  ];

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
  # TODO(Kreyn->Nikky): Plz figure this out thanku <3
  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit src version postPatch;
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
    outputHash = "sha256-cs95YI0SpvzCo5x5trMXlVUGepNKIH9oZ95AfLErKIU=";
  };

  preBuild = ''
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
