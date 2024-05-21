{ lib
, stdenv
, fetchFromGitHub
, gradle_7
, perl
, makeWrapper
, writeText
, jdk
, gsettings-desktop-schemas
}:

let
  version = "1.3.0-1";

  src = fetchFromGitHub {
    owner = "mucommander";
    repo = "mucommander";
    rev = version;
    sha256 = "sha256-rSHHv96L2EHQuKBSAdpfi1XGP2u9o2y4g1+65FHWFMw=";
  };

  postPatch = ''
    # there is no .git anyway
    substituteInPlace build.gradle \
      --replace "git = grgit.open(dir: project.rootDir)" "" \
      --replace "id 'org.ajoberstar.grgit' version '3.1.1'" "" \
      --replace "revision = git.head().id" "revision = '${version}'"
  '';

  # fake build to pre-download deps into fixed-output derivation
  deps = stdenv.mkDerivation {
    pname = "mucommander-deps";
    inherit version src postPatch;
    nativeBuildInputs = [ gradle_7 perl ];
    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d)
      gradle --no-daemon tgz
    '';
    # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    # reproducible by sorting
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | LC_ALL=C sort \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
      # copy maven-metadata.xml for commons-codec
      # thankfully there is only one xml
      cp $GRADLE_USER_HOME/caches/modules-2/resources-2.1/*/*/maven-metadata.xml $out/commons-codec/commons-codec/maven-metadata.xml
    '';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-9tCcUg7hDNbkZiQEWtVRsUUfms73aU+vt5tQsfknM+E=";
  };

in
stdenv.mkDerivation rec {
  pname = "mucommander";
  inherit version src postPatch;
  nativeBuildInputs = [ gradle_7 perl makeWrapper ];

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

  buildPhase = ''
    export GRADLE_USER_HOME=$(mktemp -d)

    gradle --offline --init-script ${gradleInit} --no-daemon tgz
  '';

  installPhase = ''
    mkdir -p $out/share/mucommander
    tar xvf build/distributions/mucommander-*.tgz --directory=$out/share/mucommander

    makeWrapper $out/share/mucommander/mucommander.sh $out/bin/mucommander \
      --prefix XDG_DATA_DIRS : ${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name} \
      --set JAVA_HOME ${jdk}
  '';

  meta = with lib; {
    homepage = "https://www.mucommander.com/";
    description = "Cross-platform file manager";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jiegec ];
    platforms = platforms.all;
    mainProgram = "mucommander";
  };
}
