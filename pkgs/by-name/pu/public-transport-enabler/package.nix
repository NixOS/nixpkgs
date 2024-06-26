{ lib
, stdenv
, fetchFromGitLab
, gradle
, perl
, writeText
}:

let
  pname = "public-transport-enabler";
  version = "20231217";

  src = fetchFromGitLab {
    owner = "oeffi";
    repo = "public-transport-enabler";
    rev = "5f0f872b67183a87e1797df5b4b9bb05fe80237d";
    hash = "sha256-8pUfg+rdTA0pTUWo3bAgNbtAGuBnWY2GJwbTlh03Rjo=";
  };

  # do not require android-specific deps
  postPatch = ''
    substituteInPlace build.gradle \
      --replace \
        "com.google.guava:guava:32.1.3-android" \
        "com.google.guava:guava:32.1.3-jre"
  '';

  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit src version postPatch;
    nativeBuildInputs = [ gradle perl ];

    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d);
      gradle --no-daemon build -x test
    '';

    # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
    '';

    dontStrip = true;

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-Yiah8Exxup9tX3xd6hinrwb7aUdqvmafStQDkmhO0pM=";
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

in stdenv.mkDerivation {
  inherit pname version src postPatch;

  nativeBuildInputs = [ gradle ];

  buildPhase = ''
    runHook preBuild
    export GRADLE_USER_HOME=$(mktemp -d)

    gradle --offline --no-daemon build -x test --init-script ${gradleInit}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/java
    cp build/libs/public-transport-enabler.jar $out/share/java
    runHook postInstall
  '';

  meta = with lib; {
    description = "Java library to get public transport data from various carriers";
    homepage = "https://gitlab.com/oeffi/public-transport-enabler/";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode   # deps
    ];
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ gm6k ];
    platforms = platforms.unix;
  };
}
