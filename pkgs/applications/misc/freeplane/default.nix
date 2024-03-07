{ stdenv
, lib
, fetchpatch
, fetchFromGitHub
, makeWrapper
, makeDesktopItem
, writeText
, runtimeShell
, jdk17
, perl
, gradle_7
, which
}:

let
  pname = "freeplane";
  version = "1.11.8";

  src_hash = "sha256-Qh2V265FvQpqGKmPsiswnC5yECwIcNwMI3/Ka9sBqXE=";
  deps_outputHash = "sha256-2Zaw4FW12dThdr082dEB1EYkGwNiayz501wIPGXUfBw=";

  jdk = jdk17;
  gradle = gradle_7;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "release-${version}";
    hash = src_hash;
  };

  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit src version;

    nativeBuildInputs = [
      jdk
      perl
      gradle
    ];

    buildPhase = ''
      GRADLE_USER_HOME=$PWD gradle -Dorg.gradle.java.home=${jdk} --no-daemon build
    '';

    # Mavenize dependency paths
    # e.g. org.codehaus.groovy/groovy/2.4.0/{hash}/groovy-2.4.0.jar -> org/codehaus/groovy/groovy/2.4.0/groovy-2.4.0.jar
    installPhase = ''
      find ./caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
      # com/squareup/okio/okio/2.10.0/okio-jvm-2.10.0.jar expected to exist under name okio-2.10.0.jar
      while IFS="" read -r -d "" path; do
        dir=''${path%/*}; file=''${path##*/}; dest=''${file//-jvm-/-}
        [[ -e $dir/$dest ]] && continue
        ln -s "$dir/$file" "$dir/$dest"
      done < <(find "$out" -type f -name 'okio-jvm-*.jar' -print0)
    '';
    # otherwise the package with a namespace starting with info/... gets moved to share/info/...
    forceShare = [ "dummy" ];

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = deps_outputHash;
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

in stdenv.mkDerivation rec {
  inherit pname version src;

  nativeBuildInputs = [
    makeWrapper
    jdk
    gradle
  ];

  buildPhase = ''
    mkdir -p freeplane/build

    GRADLE_USER_HOME=$PWD \
      gradle -Dorg.gradle.java.home=${jdk} \
      --no-daemon --offline --init-script ${gradleInit} \
      -x test \
      build
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "freeplane";
      desktopName = "freeplane";
      genericName = "Mind-mapper";
      exec = "freeplane";
      icon = "freeplane";
      comment = meta.description;
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
      --prefix PATH : ${lib.makeBinPath [ jdk which ]} \
      --prefix _JAVA_AWT_WM_NONREPARENTING : 1 \
      --prefix _JAVA_OPTIONS : "-Dawt.useSystemAAFontSettings=on"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Mind-mapping software";
    homepage = "https://freeplane.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ chaduffy ];
  };
}
