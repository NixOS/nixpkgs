{ stdenv
, fetchFromGitHub
, gradle
, jdk
, jre
, lib
, makeWrapper
, perl
, unzip
, writeText
}:

let
  pname = "excelcompare";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "na-ka-na";
    repo = "ExcelCompare";
    rev = version;
    hash = "sha256-kpKh2aSEHb5+WY12Ky/CsfUVI4pUf/7R1evZWwUsRSM=";
  };

  deps = stdenv.mkDerivation {
    name = "${pname}-deps";
    inherit src;

    nativeBuildInputs = [ gradle jdk perl ];

    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d);
      gradle --no-daemon build
    '';

    # Mavenize dependency paths
    # e.g. org.codehaus.groovy/groovy/2.4.0/{hash}/groovy-2.4.0.jar -> org/codehaus/groovy/groovy/2.4.0/groovy-2.4.0.jar
    installPhase = ''
      find "$GRADLE_USER_HOME/caches/modules-2" -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-dX2uk2OGXi9JxFmCw7u/iYG6LDE3KIjK7yA/0Ako/0o=";
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
  '';

in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [ jdk gradle makeWrapper unzip ];

  buildPhase = ''
    runHook preBuild

    export GRADLE_USER_HOME=$(mktemp -d)
    gradle --offline --no-daemon --info --init-script ${gradleInit} build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}

    # unzip the distribution since the dependencies are missing in the build/lib folder
    unzip -j build/distributions/ExcelCompare-${version}.zip 'ExcelCompare-${version}/lib/*' -d $out/lib

    jarfiles=$(find $out/lib -name '*.jar' -printf '%p:')

    makeWrapper ${jre}/bin/java $out/bin/excel_cmp \
      --add-flags "-cp $jarfiles" \
      --add-flags "com.ka.spreadsheet.diff.SpreadSheetDiffer"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Command line tool for diffing Excel Workbooks";
    homepage = "https://github.com/na-ka-na/ExcelCompare";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ elohmeier ];
  };
}
