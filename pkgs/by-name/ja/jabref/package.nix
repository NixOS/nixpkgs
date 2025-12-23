{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  wrapGAppsHook3,
  makeDesktopItem,
  copyDesktopItems,
  makeShellWrapper,
  unzip,
  zip,
  xdg-utils,
  gtk3,
  jdk25,
  openjfx25,
  gradle_9,
  python3,
  postgresql,
  jbang,
}:

let
  jdk = jdk25;
  openjfx = openjfx25;
  gradle = gradle_9;
  ltwaUrl = "https://www.issn.org/wp-content/uploads/2021/07/ltwa_20210702.csv";
  ltwa = fetchurl {
    url = ltwaUrl;
    hash = "sha256-jnS8Y9x8eg2L3L3RPnS6INTs19mEtwzfNIjJUw6HtIY=";
  };
in
stdenv.mkDerivation rec {
  version = "6.0-alpha.3";
  pname = "jabref";

  src = fetchFromGitHub {
    owner = "JabRef";
    repo = "jabref";
    tag = "v${version}";
    hash = "sha256-ZX4LQe8xKZCDJqVh+L9BHkJK82Pz/qPhlaE8SrAin6o=";
    fetchSubmodules = true;
  };

  desktopItems = [
    (makeDesktopItem {
      comment = meta.description;
      name = "JabRef";
      desktopName = "JabRef";
      genericName = "BibTex Editor";
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
    sed -i -e '/vendor/d' -e '/JavaLanguageVersion/s/24/25/' build-logic/src/main/kotlin/org.jabref.gradle.feature.compile.gradle.kts
    sed -i -e '/javafx-base/s/24.0.1/25/' build-support/src/main/java/*.java

    substituteInPlace build-support/src/main/java/*.java \
      --replace-fail 'JAVA 24' 'JAVA 25'

    sed -i -e '1a //REPOS file://${mitmCache}/https/repo.maven.apache.org/maven2,file://${mitmCache}/https/plugins.gradle.org/m2' build-support/src/main/java/*.java

    pushd jablib

    # Disable update check
    substituteInPlace src/main/java/org/jabref/logic/preferences/JabRefCliPreferences.java \
      --replace-fail 'VERSION_CHECK_ENABLED, Boolean.TRUE' \
        'VERSION_CHECK_ENABLED, Boolean.FALSE'

    # Find OpenOffice/LibreOffice binary
    substituteInPlace src/main/java/org/jabref/logic/openoffice/OpenOfficePreferences.java \
      --replace-fail '/usr' '/run/current-system/sw'

    sed -i -e '/setOutputRedirector/d' src/main/java/org/jabref/logic/search/PostgreServer.java

    substituteInPlace build.gradle.kts \
      --replace-fail '${ltwaUrl}' 'file://${ltwa}'

    popd
  '';

  nativeBuildInputs = [
    jdk
    gradle
    (jbang.override { inherit jdk; })
    wrapGAppsHook3
    copyDesktopItems
    unzip
    zip
    makeShellWrapper
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
    install -Dm644 jabgui/src/main/resources/icons/jabref.svg $out/share/pixmaps/jabref.svg

    # script to support browser extensions
    install -Dm755 jabgui/buildres/linux/jabrefHost.py $out/lib/jabrefHost.py
    patchShebangs $out/lib/jabrefHost.py
    install -Dm644 jabgui/buildres/linux/native-messaging-host/firefox/org.jabref.jabref.json $out/lib/mozilla/native-messaging-hosts/org.jabref.jabref.json
    sed -i -e "s|/opt/jabref|$out|" $out/lib/mozilla/native-messaging-hosts/org.jabref.jabref.json

    # Resources in the jar can't be found, workaround copied from AUR
    cp -r */build/resources $out/share/java/jabref

    for tarball in */build/distributions/*.tar; do
      tar xf $tarball -C $out --strip-components=1
    done

    # Temp fix: openjfx doesn't build with webkit
    unzip $out/lib/javafx-web-*-*.jar libjfxwebkit.so -d $out/lib/

    # Use postgresql from nixpkgs since the bundled binary doesn't work on NixOS
    ARCH1=${if stdenv.isAarch64 then "arm64v8" else "amd64"}
    ARCH2=${if stdenv.isAarch64 then "arm_64" else "x86_64"}
    mkdir postgresql
    cd postgresql
    ln -s ${postgresql}/{lib,share} ./
    mkdir -p bin
    ln -s ${postgresql}/bin/{postgres,initdb} ./bin
    # Wrap pg_ctl to workaround https://github.com/NixOS/nixpkgs/issues/83770
    # Use custom wrap to workaround https://github.com/NixOS/nixpkgs/issues/330471
    makeShellWrapper ${postgresql}/bin/pg_ctl ./bin/pg_ctl \
      --add-flags '-o "-k /tmp"'
    chmod +x ./bin/pg_ctl

    jar=$(ls $out/lib/embedded-postgres-binaries-linux-$ARCH1-*.jar)

    tar -cJf postgres-linux-$ARCH2.txz *
    zip $jar postgres-linux-$ARCH2.txz
    cd ..

    runHook postInstall
  '';

  postFixup = ''
    for bin in jabgui jabkit jabsrv-cli; do
      DEFAULT_JVM_OPTS=$(sed -n -E "s/^DEFAULT_JVM_OPTS='(.*)'$/\1/p" $out/bin/$bin | sed -e 's/"//g')
      MODULE_PATH=$(sed -n -E 's/^MODULE_PATH=(.*)$/\1/p' $out/bin/$bin | sed -e "s|\$APP_HOME|$out|g")
      MODULE=$(sed -n -E 's/\s*--module (.*) \\/\1/p' $out/bin/$bin)
      rm $out/bin/$bin*

      # put this in postFixup because some gappsWrapperArgs are generated in gappsWrapperArgsHook in preFixup
      makeWrapper ${jdk}/bin/java $out/bin/$bin \
        "''${gappsWrapperArgs[@]}" \
        --suffix PATH : ${
          lib.makeBinPath [
            xdg-utils
            postgresql
          ]
        } \
        --add-flags "$DEFAULT_JVM_OPTS \
          -Djava.library.path=$out/lib/:${openjfx}/modules_libs/javafx.graphics:${openjfx}/modules_libs/javafx.media \
          --module-path $MODULE_PATH \
          --module $MODULE"
    done

    # lowercase alias (for convenience and required for browser extensions)
    ln -sf $out/bin/jabgui $out/bin/jabref
    ln -sf $out/bin/jabgui $out/bin/JabRef
  '';

  gradleUpdateScript = ''
    # Add jbang deps to gradle
    sed -n 's|//DEPS \(.*\)|    implementation("\1")|p' build-support/src/main/java/*.java | sort -u | sed -i '/dependencies {/r /dev/stdin' build-logic/build.gradle.kts

    gradle assemble -Dos.arch=amd64
    gradle assemble -Dos.arch=aarch64
  '';

  meta = {
    description = "Open source bibliography reference manager";
    homepage = "https://www.jabref.org";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # source bundles dependencies as jars
      binaryNativeCode # source bundles dependencies as jars
    ];
    license = lib.licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [
      linsui
    ];
  };
}
