{ stdenv, lib, fetchpatch, fetchFromGitHub, makeWrapper, writeText, runtimeShell, jdk11, perl, gradle_5, which }:

let
  pname = "freeplane";
  version = "1.9.5";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "release-${version}";
    sha256 = "qfhhmF3mePxcL4U8izkEmWaiaOLi4slsaymVnDoO3sY=";
  };

  deps = stdenv.mkDerivation {
    name = "${pname}-deps";
    inherit src;

    nativeBuildInputs = [ jdk11 perl gradle_5 ];

    buildPhase = ''
      GRADLE_USER_HOME=$PWD gradle -Dorg.gradle.java.home=${jdk11} --no-daemon jar
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
    outputHash = "xphTzaSXTGpP7vI/t4oIiv1ZpbekG2dFRzyl3ub6qnA=";
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

  # downloaded from unicode.org and twemoji.maxcdn.com by code in freeplane/emoji.gradle
  # the below hash is for versions of freeplane that use twemoji 12.1.4, and emoji 12.1
  emoji = stdenv.mkDerivation rec {
    name = "${pname}-emoji";
    inherit src;

    nativeBuildInputs = [ jdk11 gradle_5 ];

    buildPhase = ''
      GRADLE_USER_HOME=$PWD gradle -Dorg.gradle.java.home=${jdk11} --no-daemon --offline --init-script ${gradleInit} emojiGraphicsClasses emojiListClasses
    '';

    installPhase = ''
      mkdir -p $out/emoji/txt $out/resources/images
      cp freeplane/build/emoji/txt/emojilist.txt $out/emoji/txt
      cp -r freeplane/build/emoji/resources/images/emoji/. $out/resources/images/emoji
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "0zikbakbr2fhyv4h4h52ajhznjka0hg6hiqfy1528a39i6psipn3";
  };

in stdenv.mkDerivation rec {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper jdk11 gradle_5 ];

  buildPhase = ''
    mkdir -p -- ./freeplane/build/emoji/{txt,resources/images}
    cp ${emoji}/emoji/txt/emojilist.txt ./freeplane/build/emoji/txt/emojilist.txt
    cp -r ${emoji}/resources/images/emoji ./freeplane/build/emoji/resources/images/emoji
    GRADLE_USER_HOME=$PWD gradle -Dorg.gradle.java.home=${jdk11} --no-daemon --offline --init-script ${gradleInit} -x test -x :freeplane:downloadEmoji build
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share

    cp -a ./BIN/. $out/share/${pname}
    makeWrapper $out/share/${pname}/${pname}.sh $out/bin/${pname} \
      --set FREEPLANE_BASE_DIR $out/share/${pname} \
      --set JAVA_HOME ${jdk11} \
      --prefix PATH : ${lib.makeBinPath [ jdk11 which ]}
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
