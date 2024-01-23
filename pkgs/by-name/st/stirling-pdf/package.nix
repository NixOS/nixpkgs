{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle_7,
  perl,
  makeWrapper,
  jre,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stirling-pdf";
  version = "0.22.3";

  src = fetchFromGitHub {
    owner = "Stirling-Tools";
    repo = "Stirling-PDF";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8zXTapFAXw4+KLLirxBeEBmqNw6ILFHtbsaBSP3Ehyg=";
  };

  patches = [
    # fix dependency resolution issues caused by spotless
    ./remove-spotless.patch
    # remove timestamp from the header of a generated .properties file
    ./remove-props-file-timestamp.patch
    # stripJavaArchivesHook doesn't patch signed JAR files, so instead
    # use gradle's built-in method of zeroing out timestamps
    ./fix-jar-timestamp.patch
  ];

  # fake build to pre-download deps into fixed-output derivation
  deps = stdenv.mkDerivation {
    name = "striling-pdf-${finalAttrs.version}-deps";
    inherit (finalAttrs) src patches;

    nativeBuildInputs = [
      gradle_7
      perl
    ];

    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d)
      gradle --no-daemon --console=plain build
    '';

    # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh

      # weird dependency resolution fix
      ln -s $out/com/squareup/okio/okio-jvm/3.6.0/okio-jvm-3.6.0.jar $out/com/squareup/okio/okio/3.6.0/okio-3.6.0.jar
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-33bGMRfCQZesu031wXlr05wTAPcK92DfT5mKlMkMzSo=";
  };

  nativeBuildInputs = [
    gradle_7
    makeWrapper
  ];

  # use the generated maven repository
  postPatch = ''
    sed -i "1ipluginManagement { repositories { maven { url '${finalAttrs.deps}' } } }" settings.gradle
    sed -i "s#mavenCentral()#maven { url '${finalAttrs.deps}' }#g" build.gradle
  '';

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
    description = "A locally hosted web application that allows you to perform various operations on PDF files";
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
