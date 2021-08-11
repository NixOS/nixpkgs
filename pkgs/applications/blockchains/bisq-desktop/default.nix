{ stdenv
, lib
, makeWrapper
, fetchurl
, makeDesktopItem
, copyDesktopItems
, imagemagick
, openjdk11
, dpkg
, writeScript
, coreutils
, bash
, tor
, psmisc
}:

let
  bisq-launcher = writeScript "bisq-launcher" ''
    #! ${bash}/bin/bash

    # Setup a temporary Tor instance
    TMPDIR=$(${coreutils}/bin/mktemp -d)
    CONTROLPORT=$(${coreutils}/bin/shuf -i 9100-9499 -n 1)
    SOCKSPORT=$(${coreutils}/bin/shuf -i 9500-9999 -n 1)
    ${coreutils}/bin/head -c 1024 < /dev/urandom > $TMPDIR/cookie

    ${tor}/bin/tor --SocksPort $SOCKSPORT --ControlPort $CONTROLPORT \
      --ControlPortWriteToFile $TMPDIR/port --CookieAuthFile $TMPDIR/cookie \
      --CookieAuthentication 1 >$TMPDIR/tor.log --RunAsDaemon 1

    torpid=$(${psmisc}/bin/fuser $CONTROLPORT/tcp)

    echo Temp directory: $TMPDIR
    echo Tor PID: $torpid
    echo Tor control port: $CONTROLPORT
    echo Tor SOCKS port: $SOCKSPORT
    echo Tor log: $TMPDIR/tor.log
    echo Bisq log file: $TMPDIR/bisq.log

    JAVA_TOOL_OPTIONS="-XX:MaxRAM=4g" bisq-desktop-wrapped \
      --torControlCookieFile=$TMPDIR/cookie \
      --torControlUseSafeCookieAuth \
      --torControlPort $CONTROLPORT "$@" > $TMPDIR/bisq.log

    echo Bisq exited. Killing Tor...
    kill $torpid
  '';
in
stdenv.mkDerivation rec {
  pname = "bisq-desktop";
  version = "1.7.0";

  src = fetchurl {
    url = "https://github.com/bisq-network/bisq/releases/download/v${version}/Bisq-64bit-${version}.deb";
    sha256 = "0crry5k7crmrqn14wxiyrnhk09ac8a9ksqrwwky7jsnyah0bx5k4";
  };

  nativeBuildInputs = [ makeWrapper copyDesktopItems dpkg ];

  desktopItems = [
    (makeDesktopItem {
      name = "Bisq";
      exec = "bisq-desktop";
      icon = "bisq";
      desktopName = "Bisq";
      genericName = "Decentralized bitcoin exchange";
      categories = "Network;Utility;";
    })
  ];

  unpackPhase = ''
    dpkg -x $src .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/bin
    cp opt/bisq/lib/app/desktop-${version}-all.jar $out/lib

    makeWrapper ${openjdk11}/bin/java $out/bin/bisq-desktop-wrapped \
      --add-flags "-jar $out/lib/desktop-${version}-all.jar bisq.desktop.app.BisqAppMain"

    makeWrapper ${bisq-launcher} $out/bin/bisq-desktop \
      --prefix PATH : $out/bin

    for n in 16 24 32 48 64 96 128 256; do
      size=$n"x"$n
      ${imagemagick}/bin/convert opt/bisq/lib/Bisq.png -resize $size bisq.png
      install -Dm644 -t $out/share/icons/hicolor/$size/apps bisq.png
    done;

    runHook postInstall
  '';

  meta = with lib; {
    description = "A decentralized bitcoin exchange network";
    homepage = "https://bisq.network";
    license = licenses.mit;
    maintainers = with maintainers; [ juaningan emmanuelrosa ];
    platforms = [ "x86_64-linux" ];
  };
}
