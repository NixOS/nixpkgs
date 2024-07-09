{
  lib,
  stdenv,
  fetchFromGitHub,
  substituteAll,
  gradle_7,
  perl,
  makeWrapper,
  jre,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stirling-pdf";
  version = "0.25.1";

  src = fetchFromGitHub {
    owner = "Stirling-Tools";
    repo = "Stirling-PDF";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DgQLn4+uBAF8/c3G6ckkq/0gtJEE9GPHd1d/xB6omlA=";
  };

  patches = [
    # disable spotless because it tries to fetch files not in the FOD
    # and also because it slows down the build process
    ./disable-spotless.patch
    # remove timestamp from the header of a generated .properties file
    ./remove-props-file-timestamp.patch
    # use gradle's built-in method of zeroing out timestamps,
    # because stripJavaArchivesHook can't patch signed JAR files
    ./fix-jar-timestamp.patch
    # set the FOD as the only repository gradle can resolve from
    (substituteAll {
      src = ./use-fod-maven-repo.patch;
      inherit (finalAttrs) deps;
    })
  ];

  # fake build to pre-download deps into fixed-output derivation
  deps = stdenv.mkDerivation {
    name = "${finalAttrs.pname}-${finalAttrs.version}-deps";
    inherit (finalAttrs) src;

    patches = [ ./disable-spotless.patch ];

    nativeBuildInputs = [
      gradle_7
      perl
    ];

    buildPhase = ''
      runHook preBuild

      export GRADLE_USER_HOME=$(mktemp -d)
      gradle --no-daemon --console=plain build

      runHook postBuild
    '';

    # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    installPhase = ''
      runHook preInstall

      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh

      # Mimic existence of okio-3.6.0.jar, originally known as okio-jvm-3.6.0 (and renamed).
      # Gradle doesn't detect such renames and only fetches the latter.
      # Whenever this package gets updated, please check if this hack is obsolete.
      ln -s $out/com/squareup/okio/okio-jvm/3.6.0/okio-jvm-3.6.0.jar $out/com/squareup/okio/okio/3.6.0/okio-3.6.0.jar

      runHook postInstall
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-JaTL6/DyBAqXkIQOkbi8MYoIZrhWqc3MpJ7DDB4h+ok=";
  };

  nativeBuildInputs = [
    gradle_7
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild

    export GRADLE_USER_HOME=$(mktemp -d)
    gradle --offline --no-daemon --console=plain build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 build/libs/Stirling-PDF-*.jar $out/share/stirling-pdf/Stirling-PDF.jar
    makeWrapper ${jre}/bin/java $out/bin/Stirling-PDF \
        --add-flags "-jar $out/share/stirling-pdf/Stirling-PDF.jar"

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/${finalAttrs.src.rev}";
    description = "Locally hosted web application that allows you to perform various operations on PDF files";
    homepage = "https://github.com/Stirling-Tools/Stirling-PDF";
    license = lib.licenses.gpl3Only;
    mainProgram = "Stirling-PDF";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = jre.meta.platforms;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # deps
    ];
  };
})
