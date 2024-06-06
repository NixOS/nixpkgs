{
  lib,
  stdenv,
  fetchFromGitHub,
  jdk21,
  gradle,
  perl,
  makeWrapper,
}: let
  pname = "piped-backend";
  version = "0-unstable-2024-07-11";

  src = fetchFromGitHub {
    owner = "TeamPiped";
    repo = "Piped-Backend";
    rev = "6380cea805d1bd95655e29a90321f09aeb3bb99a";
    hash = "sha256-GwdGNAlW8D1xyCpLc58UgEnvHiD1GAau7nK6iSj5FPY=";
  };

  jdk = jdk21;
  gradleWithJdk = gradle.override {java = jdk;};

  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit version src;

    nativeBuildInputs = [gradleWithJdk perl];

    buildPhase = ''
      cat <<EOF >> build.gradle
        task resolveDependencies{
          doLast{
            rootProject.allprojects{ project ->
              Set<Configuration> configurations = project.buildscript.configurations + project.configurations
              configurations.findAll{c -> c.canBeResolved}.forEach{c -> c.resolve()}
            }
          }
        }
      EOF

      export GRADLE_USER_HOME=$(mktemp -d)
      gradle --no-daemon resolveDependencies
    '';

    # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh

      # Mimic existence of okio-3.6.0.jar. Originally known as okio-jvm-3.6.0 (and renamed),
      # but gradle doesn't detect such renames, only fetches the latter and then fails
      # in `piped-backend.buildPhase` because it cannot find `okio-3.6.0.jar`.
      pushd $out/com/squareup/okio/okio/3.6.0 &>/dev/null
        cp -v ../../okio-jvm/3.6.0/okio-jvm-3.6.0.jar okio-3.6.0.jar
      popd &>/dev/null
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-OC7YKgM9UNyIC/bOdSHpon+DHvykif6V1DVrnNMJET4=";
  };
in
  stdenv.mkDerivation {
    inherit pname version src;

    nativeBuildInputs = [makeWrapper gradleWithJdk];

    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d)

      # point to offline repo
      sed -ie "1ipluginManagement { repositories { maven { url '${deps}' } } }; " settings.gradle
      sed -ie "s#mavenCentral()#mavenCentral(); maven { url '${deps}' }#g" build.gradle

      gradle --offline --no-daemon shadowJar
    '';

    installPhase = ''
      install -Dm644 build/libs/piped-1.0-all.jar $out/share/piped-backend.jar
      mkdir -p $out/bin
      makeWrapper ${jdk}/bin/java $out/bin/piped-backend \
        --add-flags "-jar $out/share/piped-backend.jar"
    '';

    meta = {
      description = "The core component behind Piped, and other alternative frontends";
      homepage = "https://github.com/TeamPiped/Piped-Backend";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [defelo];
    };
  }
