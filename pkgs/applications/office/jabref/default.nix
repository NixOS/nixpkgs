{ lib
, stdenv
, fetchFromGitHub
, wrapGAppsHook3
, makeDesktopItem
, copyDesktopItems
, unzip
, xdg-utils
, gtk3
, jdk
, gradle
, python3
}:

stdenv.mkDerivation rec {
  version = "5.13";
  pname = "jabref";

  src = fetchFromGitHub {
    owner = "JabRef";
    repo = "jabref";
    rev = "v${version}";
    hash = "sha256-inE2FXAaEEiq7343KwtjEiTEHLtn01AzP0foTpsLoAw=";
    fetchSubmodules = true;
  };

  desktopItems = [
    (makeDesktopItem {
      comment = meta.description;
      name = "JabRef";
      desktopName = "JabRef";
      genericName = "Bibliography manager";
      categories = [ "Office" ];
      icon = "jabref";
      exec = "JabRef %U";
      startupWMClass = "org.jabref.gui.JabRefGUI";
      mimeTypes = [ "text/x-bibtex" ];
    })
  ];

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  postPatch = ''
    # Disable update check
    substituteInPlace src/main/java/org/jabref/preferences/JabRefPreferences.java \
      --replace 'VERSION_CHECK_ENABLED, Boolean.TRUE' \
        'VERSION_CHECK_ENABLED, Boolean.FALSE'

    # Find OpenOffice/LibreOffice binary
    substituteInPlace src/main/java/org/jabref/logic/openoffice/OpenOfficePreferences.java \
      --replace '/usr' '/run/current-system/sw'
  '';

  nativeBuildInputs = [
    jdk
    gradle
    wrapGAppsHook3
    copyDesktopItems
    unzip
  ];

  buildInputs = [
    gtk3
    python3
  ];

  gradleFlags = [
    "-PprojVersion=${version}"
    "-Dorg.gradle.java.home=${jdk}"
  ];

  preBuild = ''
    gradleFlagsArray+=(-PprojVersionInfo="${version} NixOS")
  '';

  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    install -dm755 $out/share/java/jabref
    install -Dm644 LICENSE $out/share/licenses/jabref/LICENSE
    install -Dm644 src/main/resources/icons/jabref.svg $out/share/pixmaps/jabref.svg

    # script to support browser extensions
    install -Dm755 buildres/linux/jabrefHost.py $out/lib/jabrefHost.py
    patchShebangs $out/lib/jabrefHost.py
    install -Dm644 buildres/linux/native-messaging-host/firefox/org.jabref.jabref.json $out/lib/mozilla/native-messaging-hosts/org.jabref.jabref.json
    sed -i -e "s|/opt/jabref|$out|" $out/lib/mozilla/native-messaging-hosts/org.jabref.jabref.json

    # Resources in the jar can't be found, workaround copied from AUR
    cp -r build/resources $out/share/java/jabref

    tar xf build/distributions/JabRef-${version}.tar -C $out --strip-components=1

    DEFAULT_JVM_OPTS=$(sed -n -E "s/^DEFAULT_JVM_OPTS='(.*)'$/\1/p" $out/bin/JabRef | sed -e "s|\$APP_HOME|$out|g" -e 's/"//g')

    runHook postInstall
  '';

  postFixup = ''
    rm $out/bin/*

    # put this in postFixup because some gappsWrapperArgs are generated in gappsWrapperArgsHook in preFixup
    makeWrapper ${jdk}/bin/java $out/bin/JabRef \
      "''${gappsWrapperArgs[@]}" \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]} \
      --add-flags "-Djava.library.path=$out/lib/ --patch-module org.jabref=$out/share/java/jabref/resources/main" \
      --add-flags "$DEFAULT_JVM_OPTS"

    # lowercase alias (for convenience and required for browser extensions)
    ln -sf $out/bin/JabRef $out/bin/jabref
  '';

  gradleUpdateScript = ''
    runHook preBuild

    gradle nixDownloadDeps -Dos.arch=amd64
    gradle nixDownloadDeps -Dos.arch=aarch64
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
  };
}
