{ lib
, stdenv
, fetchurl
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
, perl
, python3
}:

let
  versionReplace = {
    easybind = {
      snapshot = "2.2.1-SNAPSHOT";
      pin = "2.2.1-20230117.075740-16";
    };
  };
in
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

  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit src version patches postPatch;

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
      mv $out/com/tobiasdiez/easybind/${versionReplace.easybind.pin} \
        $out/com/tobiasdiez/easybind/${versionReplace.easybind.snapshot}
    '';
    # Don't move info to share/
    forceShare = [ "dummy" ];
    outputHashMode = "recursive";
    outputHash = "sha256-sMbAv122EcLPOqbEVKowfxp9B71iJaccLRlKS75b3Xc=";
  };

  patches = [
    # Use JavaFX 21
    (fetchpatch {
      url = "https://github.com/JabRef/jabref/commit/2afd1f622a3ab85fc2cf5fa879c5a4d41c245eca.patch";
      hash = "sha256-cs7TSSnEY4Yf5xrqMOpfIA4jVdzM3OQQV/anQxJyy64=";
    })
  ];

  postPatch = ''
    # Pin the version
    substituteInPlace build.gradle \
      --replace 'com.tobiasdiez:easybind:${versionReplace.easybind.snapshot}' \
        'com.tobiasdiez:easybind:${versionReplace.easybind.pin}'

    # Disable update check
    substituteInPlace src/main/java/org/jabref/preferences/JabRefPreferences.java \
      --replace 'VERSION_CHECK_ENABLED, Boolean.TRUE' \
        'VERSION_CHECK_ENABLED, Boolean.FALSE'

    # Add back downloadDependencies task for deps download which is removed upstream in https://github.com/JabRef/jabref/pull/10326
    cat <<EOF >> build.gradle
    task downloadDependencies {
      description "Pre-downloads *most* dependencies"
      doLast {
        configurations.getAsMap().each { name, config ->
          println "Retrieving dependencies for $name"
          try {
            config.files
          } catch (e) {
            // some cannot be resolved, just log them
            project.logger.info e.message
          }
        }
      }
    }
    EOF
  '';

  preBuild = ''
    # Use the local packages from -deps
    sed -i -e '/repositories {/a maven { url uri("${deps}") }' \
      build.gradle \
      settings.gradle
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
