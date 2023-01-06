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
, perl
}:

stdenv.mkDerivation rec {
  version = "5.7";
  pname = "jabref";

  src = fetchFromGitHub {
    owner = "JabRef";
    repo = "jabref";
    rev = "v${version}";
    hash = "sha256-wzBaAaxGsMPh64uW+bBOiycYfVCW9H5FCn06r6XdxeE=";
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

  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit src version;

    nativeBuildInputs = [ gradle perl ];
    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d)
      gradle --no-daemon downloadDependencies
    '';
    # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/''${\($5 =~ s/-jvm//r)}" #e' \
        | sh
    '';
    # Don't move info to share/
    forceShare = [ "dummy" ];
    outputHashMode = "recursive";
    outputHash = {
      x86_64-linux = "sha256-OicHJVFxHGPE76bEDoLhkEhVcAJmplqjoh2I3nnVaLA=";
      aarch64-linux = "sha256-8QWmweptL/+pSO6DhfBLaLcBrfKd4TDsDoXs4TgXvew=";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system ${stdenv.hostPlatform.system}");
  };

  preBuild = ''
    # Include CSL styles and locales in our build
    cp -r buildres/csl/* src/main/resources/

    # Use the local packages from -deps
    sed -i -e '/repositories {/a maven { url uri("${deps}") }' \
      build.gradle \
      buildSrc/build.gradle \
      settings.gradle
  '';

  nativeBuildInputs = [
    jdk
    gradle
    wrapGAppsHook
    copyDesktopItems
    unzip
  ];

  buildInputs = [ gtk3 ];

  buildPhase = ''
    runHook preBuild

    export GRADLE_USER_HOME=$(mktemp -d)
    gradle \
      --offline \
      --no-daemon \
      -PprojVersion="${version}" \
      -PprojVersionInfo="${version} NixOS" \
      -Dorg.gradle.java.home=${jdk} \
      assemble

    runHook postBuild
  '';

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

    # workaround for https://github.com/NixOS/nixpkgs/issues/162064
    tar xf build/distributions/JabRef-${version}.tar -C $out --strip-components=1
    unzip $out/lib/javafx-web-*-linux${lib.optionalString stdenv.isAarch64 "-aarch64"}.jar libjfxwebkit.so -d $out/lib/

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
  };
}
