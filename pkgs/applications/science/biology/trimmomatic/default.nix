{
  lib,
  fetchFromGitHub,
  jre_minimal,
  makeWrapper,
  stripJavaArchivesHook,
  maven,
  nix-update-script,
}:

maven.buildMavenPackage rec {
  pname = "trimmomatic";
  version = "0.40";

  src = fetchFromGitHub {
    owner = "usadellab";
    repo = "Trimmomatic";
    rev = "v${version}";
    hash = "sha256-pLUjSVePN++G2XZrdKEdobgBO+UD0PZ9wlhSUlZ7na8=";
  };

  mvnHash = "sha256-1XnVdud8nI2SuEPXnwEmbudM+QAeoSVTn0UZ8PKJH44=";

  nativeBuildInputs = [
    makeWrapper
    stripJavaArchivesHook
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 target/trimmomatic-${version}.jar -t $out/share/trimmomatic
    cp -r adapters $out/share/trimmomatic

    makeWrapper ${lib.getBin jre_minimal}/bin/java $out/bin/trimmomatic \
        --add-flags "-jar $out/share/trimmomatic/trimmomatic-${version}.jar"

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/usadellab/Trimmomatic/releases/tag/v${version}";
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
}
