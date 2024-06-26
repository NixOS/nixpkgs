{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle_7,
  makeWrapper,
  jre,
}:

let
  pname = "stirling-pdf";
  version = "0.25.1";

  src = fetchFromGitHub {
    owner = "Stirling-Tools";
    repo = "Stirling-PDF";
    rev = "v${version}";
    hash = "sha256-DgQLn4+uBAF8/c3G6ckkq/0gtJEE9GPHd1d/xB6omlA=";
  };

  gradle = gradle_7;

in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version src;

  patches = [
    # remove timestamp from the header of a generated .properties file
    ./remove-props-file-timestamp.patch
  ];

  __darwinAllowLocalNetworking = true;

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  # disable spotless because it tries to fetch files not in deps.json
  # and also because it slows down the build process
  gradleFlags = [ "-x" "spotlessApply" ];

  nativeBuildInputs = [
    gradle
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 build/libs/Stirling-PDF-*.jar $out/share/stirling-pdf/Stirling-PDF.jar
    makeWrapper ${jre}/bin/java $out/bin/Stirling-PDF \
        --add-flags "-jar $out/share/stirling-pdf/Stirling-PDF.jar"

    runHook postInstall
  '';

  passthru.updateDeps = gradle.updateDeps { inherit pname; };

  meta = {
    changelog = "https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/${src.rev}";
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
