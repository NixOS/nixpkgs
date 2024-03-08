{ lib
, stdenvNoCC
, fetchFromGitHub
, jdk8
, makeWrapper
, jre8
, zip
}:
let
  jdk = jdk8;
  jre = jre8;
in
stdenvNoCC.mkDerivation rec {
  pname = "astral";
  version = "5.7.1";

  src = fetchFromGitHub {
    owner = "smirarab";
    repo = "ASTRAL";
    rev = "v${version}";
    sha256 = "043w2z6gbrisqirdid022f4b8jps1pp5syi344krv2bis1gjq5sn";
  };

  nativeBuildInputs = [ jdk makeWrapper jre zip ];

  buildPhase = ''
    patchShebangs ./make.sh
    ./make.sh
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    java -jar astral.${version}.jar -i main/test_data/song_primates.424.gene.tre
    runHook postCheck
  '';

  installPhase = ''
    mkdir -p $out/share/lib
    mkdir -p $out/bin
    mv astral.${version}.jar $out/share/
    mv lib/*.jar $out/share/lib
    mv Astral.${version}.zip $out/share/
    cp -a  main/test_data $out/share/
    makeWrapper ${jre}/bin/java $out/bin/astral \
        --add-flags "-jar $out/share/astral.${version}.jar"
  '';

  meta = with lib; {
    homepage = "https://github.com/smirarab/ASTRAL";
    description = "Tool for estimating an unrooted species tree given a set of unrooted gene trees";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # source bundles dependencies as jars
    ];
    license = licenses.asl20;
    maintainers = with maintainers; [ bzizou ];
  };
}
