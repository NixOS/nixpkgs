{
  lib,
  maven,
  sourcetrail,
}:
maven.buildMavenPackage rec {
  pname = "sourcetrail-java-indexer";
  version = sourcetrail.version;

  src = sourcetrail.src;

  sourceRoot = "${src.name}/java_indexer";

  mvnHash = "sha256-7yUB/e+Na4bC/gIPZAqysa2QPxfsHNR6rqS5z+HmLDI";

  mvnParameters = "-Dmaven.test.skip=true";

  installPhase = ''
    mkdir -p $out/
    cp ./target/*.jar $out/
  '';

  meta = with lib; {
    description = "Java indexer for Sourcetrail";
    homepage = "https://sourcetrail.de";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ eownerdead ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
  };
}
