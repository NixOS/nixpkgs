{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  makeDesktopItem,
  writeText,
  jdk17,
  perl,
  gradle_7,
  which,
}:

let
  pname = "freeplane";
  version = "1.11.14";

  jdk = jdk17;
  gradle = gradle_7;

  src = fetchFromGitHub {
    owner = "freeplane";
    repo = "freeplane";
    rev = "release-${version}";
    hash = "sha256-zEQjB57iiKVQnH8VtynpEGKNAa2e+WpqnGt6fnv5Rjs=";
  };

  deps = stdenvNoCC.mkDerivation {
    pname = "${pname}-deps";
    inherit src version;

    nativeBuildInputs = [
      jdk
      perl
      gradle
    ];

    buildPhase = ''
      runHook preBuild
      GRADLE_USER_HOME=$PWD gradle -Dorg.gradle.java.home=${jdk} --no-daemon build
      runHook postBuild
    '';

    # Mavenize dependency paths
    # e.g. org.codehaus.groovy/groovy/2.4.0/{hash}/groovy-2.4.0.jar -> org/codehaus/groovy/groovy/2.4.0/groovy-2.4.0.jar
    installPhase = ''
      runHook preInstall
      find ./caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
      # com/squareup/okio/okio-jvm/x.y.z/okio-jvm-x.y.z.jar is expected to exist under com/squareup/okio/okio/x.y.z/okio-x.y.z.jar
      while IFS="" read -r -d "" path; do
        ln -s "$path" ''${path//okio-jvm/okio}
      done < <(find "$out" -type f -name 'okio-jvm-*.jar' -print0)
      runHook postInstall
    '';
    # otherwise the package with a namespace starting with info/... gets moved to share/info/...
    forceShare = [ "dummy" ];

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-mWQTe/hOWGwWtsUPCZ7gle2FtskcEmJwsGQZITEc/Uc=";
  };

  # Point to our local deps repo
  gradleInit = writeText "init.gradle" ''
    settingsEvaluated { settings ->
      settings.pluginManagement {
        repositories {
          clear()
          maven { url '${deps}' }
        }
      }
    }
    gradle.projectsLoaded {
      rootProject.allprojects {
        repositories {
          clear()
          maven { url '${deps}' }
        }
      }
    }
  '';
in
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version src;

  nativeBuildInputs = [
    makeBinaryWrapper
    jdk
    gradle
  ];

  buildPhase = ''
    runHook preBuild
    mkdir -p freeplane/build

    GRADLE_USER_HOME=$PWD \
      gradle -Dorg.gradle.java.home=${jdk} \
      --no-daemon --offline --init-script ${gradleInit} \
      -x test \
      build
    runHook postBuild
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "freeplane";
      desktopName = "freeplane";
      genericName = "Mind-mapper";
      exec = "freeplane";
      icon = "freeplane";
      comment = finalAttrs.meta.description;
      mimeTypes = [
        "application/x-freemind"
        "application/x-freeplane"
        "text/x-troff-mm"
      ];
      categories = [
        "2DGraphics"
        "Chart"
        "Graphics"
        "Office"
      ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    cp -a ./BIN/. $out/share/freeplane

    makeWrapper $out/share/freeplane/freeplane.sh $out/bin/freeplane \
      --set FREEPLANE_BASE_DIR $out/share/freeplane \
      --set JAVA_HOME ${jdk} \
      --prefix PATH : ${
        lib.makeBinPath [
          jdk
          which
        ]
      } \
      --prefix _JAVA_AWT_WM_NONREPARENTING : 1 \
      --prefix _JAVA_OPTIONS : "-Dawt.useSystemAAFontSettings=on"

    runHook postInstall
  '';

  meta = {
    description = "Mind-mapping software";
    homepage = "https://freeplane.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ chaduffy ];
    mainProgram = "freeplane";
  };
})
