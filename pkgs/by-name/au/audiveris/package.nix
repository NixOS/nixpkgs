{ lib
, stdenv
, fetchFromGitHub
, gradle
, jre
, makeWrapper
, perl
, tesseract5
, writeText
, runtimeShell
}:

let
  pname = "audiveris";
  version = "5.3.1";

  src = fetchFromGitHub {
    owner = "Audiveris";
    repo = "audiveris";
    rev = "${version}";
    hash = "sha256-feUaNnAZRZHJd+NvwgM+YwaEXjH9GqlkPH5BgWzubYs=";
  };

  # we usually don't have access to the commit hashes
  postPatch = ''
    substituteInPlace build.gradle \
      --replace "git rev-parse --short HEAD" "echo nixos"
    echo "compileJava.options.encoding = 'UTF-8'" >> build.gradle
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
    outputHash = {
      x86_64-linux = "sha256-+EcN2c4eXL8EEZs6paPHadMiSZGHCvAxwzSaBoBIu18=";
      aarch64-linux = "sha256-8/6UVtLzkMVtSnY9FiXZqpK15kLY6t/Nj0h5GBsFbe8=";
      x86_64-darwin = "sha256-qzfGCvo8Y41YbpRJ4z6eo+2820Uq2lo01QTfPCmiP+0=";
      aarch64-darwin = "sha256-urxXRbc+1vZMUl5+ZennwkAHr58i8XLibm+pGmsFX5I=";
    }.${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
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

  nativeBuildInputs = [ gradle makeWrapper ];

  buildPhase = ''
    runHook preBuild
    export GRADLE_USER_HOME=$(mktemp -d)

    gradle --offline --no-daemon build -x test --init-script ${gradleInit}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir $out
    cat build/distributions/Audiveris-${version}.tar |
      (cd $out;tar xv --strip-components=1)
    rm $out/bin/Audiveris.bat
    wrapProgram $out/bin/Audiveris \
      --set JAVA_HOME ${jre} \
      --set TESSDATA_PREFIX "${tesseract5}/share/tessdata"
    runHook postInstall
  '';

  meta = with lib; {
    description = "open-source optical music recognition engine";
    homepage = "https://audiveris.github.io/audiveris/";
    mainProgram = "Audiveris";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode   # deps
      binaryNativeCode # deps (tesseract, leptonica)
    ];
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ gm6k ];
    platforms = platforms.unix;
  };
}
