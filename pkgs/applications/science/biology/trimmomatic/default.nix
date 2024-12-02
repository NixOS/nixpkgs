{ lib
, stdenv
, fetchFromGitHub
, ant
, jdk
, jre
, makeWrapper
, stripJavaArchivesHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "trimmomatic";
  version = "0.39";

  src = fetchFromGitHub {
    owner = "usadellab";
    repo = "Trimmomatic";
    rev = "v${finalAttrs.version}";
    hash = "sha256-u+ubmacwPy/vsEi0YQCv0fTnVDesQvqeQDEwCbS8M6I=";
  };

  # Remove jdk version requirement
  postPatch = ''
    substituteInPlace ./build.xml \
      --replace 'source="1.5" target="1.5"' ""
  '';

  nativeBuildInputs = [
    ant
    jdk
    makeWrapper
    stripJavaArchivesHook
  ];

  buildPhase = ''
    runHook preBuild

    ant

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 dist/jar/trimmomatic-*.jar -t $out/share/trimmomatic
    cp -r adapters $out/share/trimmomatic

    makeWrapper ${jre}/bin/java $out/bin/trimmomatic \
        --add-flags "-jar $out/share/trimmomatic/trimmomatic-*.jar"

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/usadellab/Trimmomatic/blob/main/versionHistory.txt";
    description = "Flexible read trimming tool for Illumina NGS data";
    longDescription = ''
      Trimmomatic performs a variety of useful trimming tasks for illumina
      paired-end and single ended data: adapter trimming, quality trimming,
      cropping to a specified length, length filtering, quality score
      conversion.
    '';
    homepage = "http://www.usadellab.org/cms/?page=trimmomatic";
    downloadPage = "https://github.com/usadellab/Trimmomatic/releases";
    license = lib.licenses.gpl3Only;
    sourceProvenance = [
      lib.sourceTypes.fromSource
      lib.sourceTypes.binaryBytecode # source bundles dependencies as jars
    ];
    mainProgram = "trimmomatic";
    maintainers = [ lib.maintainers.kupac ];
  };
})
