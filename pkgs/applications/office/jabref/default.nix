{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, wrapGAppsHook
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
  version = "5.11";
  pname = "jabref";

  src = fetchFromGitHub {
    owner = "JabRef";
    repo = "jabref";
    rev = "v${version}";
    hash = "sha256-MTnM4QHTFXJt/T8SOWwHlZ1CuegSGjpT3qDaMRi5n18=";
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
      startupWMClass = "org.jabref.gui.JabRefMain";
      mimeTypes = [ "text/x-bibtex" ];
    })
  ];

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  patches = [
    # Use JavaFX 21
    (fetchpatch {
      url = "https://github.com/JabRef/jabref/commit/2afd1f622a3ab85fc2cf5fa879c5a4d41c245eca.patch";
      hash = "sha256-cs7TSSnEY4Yf5xrqMOpfIA4jVdzM3OQQV/anQxJyy64=";
    })
  ];

  postPatch = ''
    # Disable update check
    substituteInPlace src/main/java/org/jabref/preferences/JabRefPreferences.java \
      --replace 'VERSION_CHECK_ENABLED, Boolean.TRUE' \
        'VERSION_CHECK_ENABLED, Boolean.FALSE'
  '';

  nativeBuildInputs = [
    jdk
    gradle
    wrapGAppsHook
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

  preConfigure = ''
    gradleFlagsArray+=(-PprojVersionInfo="${version} NixOS")
  '';

  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    install -dm755 $out/share/java/jabref
    install -Dm644 LICENSE.md $out/share/licenses/jabref/LICENSE.md
    install -Dm644 src/main/resources/icons/jabref.svg $out/share/pixmaps/jabref.svg

    # script to support browser extensions
    install -Dm755 buildres/linux/jabrefHost.py $out/lib/jabrefHost.py
    patchShebangs $out/lib/jabrefHost.py
    install -Dm644 buildres/linux/native-messaging-host/firefox/org.jabref.jabref.json $out/lib/mozilla/native-messaging-hosts/org.jabref.jabref.json
    sed -i -e "s|/opt/jabref|$out|" $out/lib/mozilla/native-messaging-hosts/org.jabref.jabref.json

    # Resources in the jar can't be found, workaround copied from AUR
    cp -r build/resources $out/share/java/jabref

    tar xf build/distributions/JabRef-${version}.tar -C $out --strip-components=1

    # workaround for https://github.com/NixOS/nixpkgs/issues/162064
    unzip $out/lib/javafx-web-*-*.jar libjfxwebkit.so -d $out/lib/

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

  passthru.updateDeps = gradle.updateDeps {
    inherit pname;
    gradleCommands = ''
      gradle nixDownloadDeps -Dos.arch=amd64
      gradle nixDownloadDeps -Dos.arch=aarch64
    '';
  };

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
