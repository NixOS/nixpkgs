{ stdenv, lib, fetchpatch, fetchFromGitHub, makeWrapper, writeText, runtimeShell, jdk11, perl, gradle_6, which }:

let
  pname = "freeplane";
  version = "1.9.14";

  src_sha256 = "UiXtGJs+hibB63BaDDLXgjt3INBs+NfMsKcX2Q/kxKw=";
  deps_outputHash = "tHhRaMIQK8ERuzm+qB9tRe2XSesL0bN3rComB9/qWgg=";
  emoji_outputHash = "w96or4lpKCRK8A5HaB4Eakr7oVSiQALJ9tCJvKZaM34=";

  jdk = jdk11;
  gradle = gradle_6;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "release-${version}";
    sha256 = src_sha256;
  };

  deps = stdenv.mkDerivation {
    name = "${pname}-deps";
    inherit src;

    nativeBuildInputs = [ jdk perl gradle ];

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

    nativeBuildInputs = [ jdk gradle ];

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

  nativeBuildInputs = [ makeWrapper jdk gradle ];

  buildPhase = ''
    mkdir -p -- ./freeplane/build/emoji/{txt,resources/images}
    cp ${emoji}/emoji/txt/emojilist.txt ./freeplane/build/emoji/txt/emojilist.txt
    cp -r ${emoji}/resources/images/emoji ./freeplane/build/emoji/resources/images/emoji
    GRADLE_USER_HOME=$PWD gradle -Dorg.gradle.java.home=${jdk} --no-daemon --offline --init-script ${gradleInit} -x test -x :freeplane:downloadEmoji build
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share

    cp -a ./BIN/. $out/share/${pname}
    makeWrapper $out/share/${pname}/${pname}.sh $out/bin/${pname} \
      --set FREEPLANE_BASE_DIR $out/share/${pname} \
      --set JAVA_HOME ${jdk} \
      --prefix PATH : ${lib.makeBinPath [ jdk which ]}
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
