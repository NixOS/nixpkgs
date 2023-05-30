{ lib
, stdenv
, fetchFromGitHub
, wrapGAppsHook
, makeDesktopItem
, copyDesktopItems
, unzip
, xdg-utils
, gtk3
, jdk
, gradle
}:
let
  info = if stdenv.isx86_64 then {
    platformFlag = "-Dos.arch=amd64";
    depsHash = "sha256-zjvcnK3ssWXoGZtc0sgwWRhygIJ5bapFNFh1F9Ewe9k=";
    lockfileTree = ./amd64;
    # -Dos.arch=aarch64
  } else (throw "Unsupported platform");
in
gradle.buildPackage rec {
  version = "5.9";
  pname = "jabref";

  src = fetchFromGitHub {
    owner = "JabRef";
    repo = "jabref";
    rev = "v${version}";
    hash = "sha256-uACmXas5L1NcxLwllkcbgCCt9bRicpQkiJkhkkVWDDY=";
  };

  desktopItems = [
    (makeDesktopItem {
      comment = meta.description;
      name = "JabRef %U";
      desktopName = "JabRef";
      genericName = "Bibliography manager";
      categories = [ "Office" ];
      icon = "jabref";
      exec = "JabRef";
      startupWMClass = "org.jabref.gui.JabRefMain";
      mimeTypes = [ "text/x-bibtex" ];
    })
  ];

  gradleOpts = {
    inherit (info) depsHash lockfileTree;
    flags = [
      info.platformFlag
      "-PprojVersion=${version}"
      "-PprojVersionInfo=${version} NixOS"
      "-Dorg.gradle.java.home=${jdk}"
      "--debug"
    ];
    buildSubcommand = "assemble";
  };

  preBuild = ''
    # Include CSL styles and locales in our build
    cp -r buildres/csl/* src/main/resources/
  '';

  nativeBuildInputs = [
    jdk
    wrapGAppsHook
    copyDesktopItems
    unzip
  ];

  buildInputs = [ gtk3 ];

  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    install -dm755 $out/share/java/jabref
    install -Dm644 LICENSE.md $out/share/licenses/jabref/LICENSE.md
    install -Dm644 src/main/resources/icons/jabref.svg $out/share/pixmaps/jabref.svg

    # script to support browser extensions
    install -Dm755 buildres/linux/jabrefHost.py $out/lib/jabrefHost.py
    install -Dm644 buildres/linux/native-messaging-host/firefox/org.jabref.jabref.json $out/lib/mozilla/native-messaging-hosts/org.jabref.jabref.json
    sed -i -e "s|/opt/jabref|$out|" $out/lib/mozilla/native-messaging-hosts/org.jabref.jabref.json

    # Resources in the jar can't be found, workaround copied from AUR
    cp -r build/resources $out/share/java/jabref

    tar xf build/distributions/JabRef-${version}.tar -C $out --strip-components=1

    # remove openjfx libs for other platforms
    rm $out/lib/javafx-*-win.jar ${lib.optionalString stdenv.isAarch64 "$out/lib/javafx-*-linux.jar"}

    # workaround for https://github.com/NixOS/nixpkgs/issues/162064
    unzip $out/lib/javafx-web-*.jar libjfxwebkit.so -d $out/lib/

    DEFAULT_JVM_OPTS=$(sed -n -E "s/^DEFAULT_JVM_OPTS='(.*)'$/\1/p" $out/bin/JabRef | sed -e "s|\$APP_HOME|$out|g" -e 's/"//g')
    rm $out/bin/*

    makeWrapper ${jdk}/bin/java $out/bin/JabRef \
      "''${gappsWrapperArgs[@]}" \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]} \
      --add-flags "-Djava.library.path=$out/lib/ --patch-module org.jabref=$out/share/java/jabref/resources/main" \
      --add-flags "$DEFAULT_JVM_OPTS"

    # lowercase alias (for convenience and required for browser extensions)
    ln -sf $out/bin/JabRef $out/bin/jabref

    runHook postInstall
  '';

  meta = with lib; {
    description = "Open source bibliography reference manager";
    homepage = "https://www.jabref.org";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode # source bundles dependencies as jars
      binaryNativeCode # source bundles dependencies as jars
    ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ gebner linsui ];
    broken = true;
  };
}
