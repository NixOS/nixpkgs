{ stdenv
, jdk17
, gradle_7
, lib
, fetchFromGitHub
, jre
, perl
, git
, util-linux
}:

let
  pname = "pkl";
  version = "0.25.1";
  src = fetchFromGitHub {
    owner = "apple";
    repo = "pkl";
    rev = "0.25.1";
    sha256 = "sha256-/I1dxGXYVUClEQXXtSqEyopClNTqseeWpAiyeaPrIGo=";
  };

  # fake build to pre-download deps into fixed-output derivation
  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit src version;

    nativeBuildInputs = [
      git
      gradle_7
      jdk17
      perl
    ];

    # Here we download dependencies for both the server and the client so
    # we only have to specify one hash for 'deps'. Deps can be garbage
    # collected after the build, so this is not really an issue.
    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d)
      # https://github.com/apple/pkl/issues/66
      gradle --no-daemon \
        bench:dependencies \
        docs:dependencies \
        pkl-cli:dependencies \
        pkl-codegen-java:dependencies \
        pkl-codegen-kotlin:dependencies \
        pkl-commons:dependencies \
        pkl-commons-cli:dependencies \
        pkl-commons-test:dependencies \
        pkl-config-java:dependencies \
        pkl-config-kotlin:dependencies \
        pkl-core:dependencies \
        pkl-doc:dependencies \
        pkl-executor:dependencies \
        pkl-gradle:dependencies \
        pkl-server:dependencies \
        pkl-tools:dependencies \
        stdlib:dependencies \
        bench:spotlessJava
    '';

    # Taken from Mindustry derivation
    # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh

      # For some reason, some of the jars, but not all, had the unexpected
      # string "-gradle70" before its extension. This snippet removes it
      find "$out" -type f -iname "*-gradle70.jar" -exec ${util-linux}/bin/rename -- "-gradle70" "" {} \;
    '';
    outputHashMode = "recursive";
    outputHash = "sha256-iLC2WI9UJWOQ14U6Rd+B+8OPD/ji+aTsjUT+YMbJuv0=";
  };
in
stdenv.mkDerivation rec {
  inherit pname version src deps;

  nativeBuildInputs = [
    git
    gradle_7
    jdk17
  ];

  buildInputs = [
    jre
  ];

  buildPhase = ''
    export GRADLE_USER_HOME=$(mktemp -d)
    sed -ie "s#repositories {#repositories { maven { url = uri(\"${deps}\") }#g" settings.gradle.kts
    sed -ie "s#repositories {#repositories { maven { url = uri(\"${deps}\") }#g" ./buildSrc/src/main/kotlin/pklAllProjects.gradle.kts
    sed -ie "s#repositories {#repositories { maven { url = uri(\"${deps}\") }#g" ./pkl-gradle/src/test/kotlin/org/pkl/gradle/JavaCodeGeneratorsTest.kt
    sed -ie "s#repositories {#repositories { maven { url = uri(\"${deps}\") }#g" ./pkl-gradle/src/test/kotlin/org/pkl/gradle/KotlinCodeGeneratorsTest.kt
    sed -ie "s#repositories {#repositories { maven { url = uri(\"${deps}\") }#g" ./buildSrc/settings.gradle.kts

    gradle --no-daemon --offline --info --stacktrace build
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "./pkl-cli/build/executable/jpkl" "$out/bin/pkl"
  '';

  meta = with lib; {
    description = "A configuration as code language with rich validation and tooling. ";
    homepage = "https://pkl-lang.org/main/current/index.html";
    licence = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ rafaelrc ];
    mainProgram = "pkl";
  };
}

