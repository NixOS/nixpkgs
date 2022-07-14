{ stdenv
, lib
, fetchpatch
, fetchFromGitHub
, makeWrapper
, makeDesktopItem
, writeText
, runtimeShell
, jdk11
, perl
, gradle_6
, which
}:

let
  pname = "freeplane";
  version = "1.10.5";

  src_hash = lib.fakeHash;
  deps_outputHash = lib.fakeSha256;
  emoji_outputHash = lib.fakeSha256;

  jdk = jdk11;
  gradle = gradle_6;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "release-${version}";
    hash = src_hash;
  };

  deps = stdenv.mkDerivation {
    name = "${pname}-deps";
    inherit src;

    nativeBuildInputs = [
      jdk
      perl
      gradle
    ];

    buildPhase = ''
      GRADLE_USER_HOME=$PWD gradle -Dorg.gradle.java.home=${jdk} --no-daemon jar
    '';

    # Mavenize dependency paths
    # e.g. org.codehaus.groovy/groovy/2.4.0/{hash}/groovy-2.4.0.jar -> org/codehaus/groovy/groovy/2.4.0/groovy-2.4.0.jar
    installPhase = ''
      find ./caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = deps_outputHash;
  };

  # Point to our local deps repo
  gradleInit = writeText "init.gradle" ''
    logger.lifecycle 'Replacing Maven repositories with ${deps}...'
    gradle.projectsLoaded {
      rootProject.allprojects {
        buildscript {
          repositories {
            clear()
            maven { url '${deps}' }
          }
        }
        repositories {
          clear()
          maven { url '${deps}' }
        }
      }
    }
    settingsEvaluated { settings ->
      settings.pluginManagement {
        repositories {
          maven { url '${deps}' }
        }
      }
    }
  '';

  emoji = stdenv.mkDerivation rec {
    name = "${pname}-emoji";
    inherit src;

    nativeBuildInputs = [
      jdk
      gradle
    ];

    buildPhase = ''
      GRADLE_USER_HOME=$PWD gradle -Dorg.gradle.java.home=${jdk} --no-daemon --offline --init-script ${gradleInit} :freeplane:downloadEmoji
    '';

    installPhase = ''
      mkdir -p $out/emoji/txt $out/resources/images
      cp freeplane/build/emoji/txt/emojilist.txt $out/emoji/txt
      cp -r freeplane/build/emoji/resources/images/emoji/. $out/resources/images/emoji
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = emoji_outputHash;
  };

in stdenv.mkDerivation rec {
  inherit pname version src;

  nativeBuildInputs = [
    makeWrapper
    jdk
    gradle
  ];

  buildPhase = ''
    mkdir -p -- ./freeplane/build
    ln -s ${emoji}/emoji ./freeplane/build/emoji

    GRADLE_USER_HOME=$PWD \
      gradle -Dorg.gradle.java.home=${jdk} \
      --no-daemon --offline --init-script ${gradleInit} \
      -x test -x :freeplane:downloadEmoji \
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
    maintainers = with maintainers; [
      chaduffy
    ];
  };
}
