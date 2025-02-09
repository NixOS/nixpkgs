{ lib
, stdenv
, ant
, fetchFromGitHub
, jdk11_headless
, jre
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "trimmomatic";
  version = "0.39";

  src = fetchFromGitHub {
    owner = "usadellab";
    repo = "Trimmomatic";
    rev = "v${version}";
    hash = "sha256-u+ubmacwPy/vsEi0YQCv0fTnVDesQvqeQDEwCbS8M6I=";
  };

  # Set source and target version to 11
  postPatch = ''
    substituteInPlace ./build.xml \
      --replace 'source="1.5" target="1.5"' 'release="11"'
  '';

  nativeBuildInputs = [ jdk11_headless ant makeWrapper ];

  buildPhase = ''
    runHook preBuild

    ant

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    cp dist/jar/trimmomatic-${version}.jar $out/share/
    cp -r adapters $out/share/
    makeWrapper ${jre}/bin/java $out/bin/trimmomatic \
      --add-flags "-cp $out/share/trimmomatic-${version}.jar org.usadellab.trimmomatic.Trimmomatic"

    runHook postInstall
  '';

  meta = {
    description = "A flexible read trimming tool for Illumina NGS data";
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
      lib.sourceTypes.binaryBytecode  # source bundles dependencies as jars
    ];
    maintainers = [ lib.maintainers.kupac ];
  };
}
