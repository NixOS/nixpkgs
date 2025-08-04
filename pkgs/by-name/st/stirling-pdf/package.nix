{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle_8,
  makeWrapper,
  jre,
}:

let
  gradle = gradle_8;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "stirling-pdf";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Stirling-Tools";
    repo = "Stirling-PDF";
    rev = "v${finalAttrs.version}";
    hash = "sha256-g5ugvnnFUXBfYFN1Z5+m9HTVSZ5KS9HGkIte3lKi/sA=";
  };

  patches = [
    # remove timestamp from the header of a generated .properties file
    ./remove-props-file-timestamp.patch
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  # disable spotless because it tries to fetch files not in deps.json
  # and also because it slows down the build process
  gradleFlags = [
    "-x"
    "spotlessApply"
    "-DDISABLE_ADDITIONAL_FEATURES=true"
  ];

  doCheck = true;

  nativeBuildInputs = [
    gradle
    gradle.jdk # one of the tests also require that the `java` command is available on the command line
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 ./app/core/build/libs/stirling-pdf-*.jar $out/share/stirling-pdf/Stirling-PDF.jar
    makeWrapper ${lib.getExe jre} $out/bin/Stirling-PDF \
      --add-flags "-jar $out/share/stirling-pdf/Stirling-PDF.jar"

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v${finalAttrs.version}";
    description = "Locally hosted web application that allows you to perform various operations on PDF files";
    homepage = "https://github.com/Stirling-Tools/Stirling-PDF";
    license = lib.licenses.mit;
    mainProgram = "Stirling-PDF";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = jre.meta.platforms;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # deps
    ];
  };
})
