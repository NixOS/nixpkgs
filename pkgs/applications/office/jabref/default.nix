{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, unzip
, xdg-utils
, jdk
, gradle
, perl
}:

stdenv.mkDerivation rec {
  version = "5.6";
  pname = "jabref";

  src = fetchFromGitHub {
    owner = "JabRef";
    repo = "jabref";
    rev = "v${version}";
    hash = "sha256-w3F1td7KmdSor/2vKar3w17bChe1yH7JMobOaCjZqd4=";
  };

  desktopItems = [
    (makeDesktopItem {
      comment = meta.description;
      name = "jabref";
      desktopName = "JabRef";
      genericName = "Bibliography manager";
      categories = [ "Office" ];
      icon = "jabref";
      exec = "jabref";
    })
  ];

  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit src version;

    postPatch = ''
        sed -i -e '/testImplementation/d' -e '/testRuntimeOnly/d' build.gradle
        echo 'dependencyLocking { lockAllConfigurations() }' >> build.gradle
        cp ${./gradle.lockfile} ./
      '';

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
      x86_64-linux = "sha256-ySGXZM9LCJUjGCrKMc+5I6duEbmSsp3tU3t/o5nM+5M=";
      aarch64-linux = "sha256-mfWyGGBqjRQ8q9ddR57O2rwtby2T1H6Ra2m0JGVZ1Zs=";
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
    makeWrapper
    copyDesktopItems
    unzip
  ];

  buildPhase = ''
    runHook preBuild

    export GRADLE_USER_HOME=$(mktemp -d)
    gradle \
      --offline \
      --no-daemon \
      -PprojVersion="${version}" \
      -PprojVersionInfo="${version} NixOS" \
      assemble

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -dm755 $out/share/java/jabref
    install -Dm644 LICENSE.md $out/share/licenses/jabref/LICENSE.md
    install -Dm644 src/main/resources/icons/jabref.svg $out/share/pixmaps/jabref.svg

    # script to support browser extensions
    install -Dm755 buildres/linux/jabrefHost.py $out/lib/jabrefHost.py
    # This can be removed in the next version
    sed -i -e "/importBibtex/s/{}/'{}'/" $out/lib/jabrefHost.py
    install -Dm644 buildres/linux/native-messaging-host/firefox/org.jabref.jabref.json $out/lib/mozilla/native-messaging-hosts/org.jabref.jabref.json
    sed -i -e "s|/opt/jabref|$out|" $out/lib/mozilla/native-messaging-hosts/org.jabref.jabref.json

    # Resources in the jar can't be found, workaround copied from AUR
    cp -r build/resources $out/share/java/jabref

    # workaround for https://github.com/NixOS/nixpkgs/issues/162064
    tar xf build/distributions/JabRef-${version}.tar -C $out --strip-components=1
    unzip $out/lib/javafx-web-18-linux${lib.optionalString stdenv.isAarch64 "-aarch64"}.jar libjfxwebkit.so -d $out/lib/

    wrapProgram $out/bin/JabRef \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]} \
      --set JAVA_HOME "${jdk}" \
      --set JAVA_OPTS "-Djava.library.path=$out/lib/ --patch-module org.jabref=$out/share/java/jabref/resources/main"

    # lowercase alias (for convenience and required for browser extensions)
    ln -sf $out/bin/JabRef $out/bin/jabref

    runHook postInstall
  '';

  meta = with lib; {
    description = "Open source bibliography reference manager";
    homepage = "https://www.jabref.org";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # source bundles dependencies as jars
      binaryNativeCode  # source bundles dependencies as jars
    ];
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ gebner linsui ];
  };
}
