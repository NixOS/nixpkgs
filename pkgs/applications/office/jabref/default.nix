{ lib
, stdenv
, fetchurl
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
, python3
}:

let
  versionReplace = {
    easybind = {
      snapshot = "2.2.1-SNAPSHOT";
      pin = "2.2.1-20230117.075740-16";
    };
    afterburner = {
      snapshot = "1.1.0-SNAPSHOT";
      pin = "1.1.0-20221226.155809-7";
    };
  };
in
stdenv.mkDerivation rec {
  version = "5.10";
  pname = "jabref";

  src = fetchFromGitHub {
    owner = "JabRef";
    repo = "jabref";
    rev = "v${version}";
    hash = "sha256-Yj4mjXOZVM0dKcMfTjmnZs/kIs8AR0KJ9HKlyPM96j8=";
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

  deps =
    let
      javafx-web = fetchurl {
        url = "https://repo1.maven.org/maven2/org/openjfx/javafx-web/20/javafx-web-20.jar";
        hash = "sha256-qRtVN34KURlVM5Ie/x25IfKsKsUcux7V2m3LML74G/s=";
      };
    in
    stdenv.mkDerivation {
      pname = "${pname}-deps";
      inherit src version postPatch;

      nativeBuildInputs = [ gradle perl ];
      buildPhase = ''
        export GRADLE_USER_HOME=$(mktemp -d)
        gradle --no-daemon downloadDependencies -Dos.arch=amd64
        gradle --no-daemon downloadDependencies -Dos.arch=aarch64
      '';
      # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
      installPhase = ''
        find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
          | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/''${\($5 =~ s/-jvm//r)}" #e' \
          | sh
        mv $out/org/jabref/afterburner.fx/${versionReplace.afterburner.pin} \
          $out/org/jabref/afterburner.fx/${versionReplace.afterburner.snapshot}
        mv $out/com/tobiasdiez/easybind/${versionReplace.easybind.pin} \
          $out/com/tobiasdiez/easybind/${versionReplace.easybind.snapshot}
        # This jar is required but not used or cached for unknown reason.
        cp ${javafx-web} $out/org/openjfx/javafx-web/20/javafx-web-20.jar
      '';
      # Don't move info to share/
      forceShare = [ "dummy" ];
      outputHashMode = "recursive";
      outputHash = "sha256-XswHEKjzErL+znau/F6mTORVJlFSgVuT0svK29v5dEU=";
    };

  postPatch = ''
    # Pin the version
    substituteInPlace build.gradle \
      --replace 'org.jabref:afterburner.fx:${versionReplace.afterburner.snapshot}' \
        'org.jabref:afterburner.fx:${versionReplace.afterburner.pin}' \
      --replace 'com.tobiasdiez:easybind:${versionReplace.easybind.snapshot}' \
        'com.tobiasdiez:easybind:${versionReplace.easybind.pin}'

    # Disable update check
    substituteInPlace src/main/java/org/jabref/preferences/JabRefPreferences.java \
      --replace 'VERSION_CHECK_ENABLED, Boolean.TRUE' \
        'VERSION_CHECK_ENABLED, Boolean.FALSE'
  '';

  preBuild = ''
    # Include CSL styles and locales in our build
    cp -r buildres/csl/* src/main/resources/

    # Use the local packages from -deps
    sed -i -e '/repositories {/a maven { url uri("${deps}") }' \
      build.gradle \
      buildSrc/build.gradle \
      settings.gradle

    # The `plugin {}` block can't resolve plugins from the deps repo
    sed -e '/plugins {/,/^}/d' buildSrc/build.gradle > buildSrc/build.gradle.tmp
    cat > buildSrc/build.gradle <<EOF
    buildscript {
      repositories { maven { url uri("${deps}") } }
      dependencies { classpath 'org.openjfx:javafx-plugin:0.0.14' }
    }
    apply plugin: 'java'
    apply plugin: 'org.openjfx.javafxplugin'
    EOF
    cat buildSrc/build.gradle.tmp >> buildSrc/build.gradle
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
