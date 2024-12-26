{
  lib,
  stdenvNoCC,
  ant,
  fetchurl,
  jdk,
  nixosTests,
  stripJavaArchivesHook,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "axis2";
  version = "1.8.2";

  src = fetchurl {
    url = "mirror://apache/axis/axis2/java/core/${finalAttrs.version}/axis2-${finalAttrs.version}-bin.zip";
    hash = "sha256-oilPVFFpl3F61nVDxcYx/bc81FopS5fzoIdXzeP8brk=";
  };

  nativeBuildInputs = [
    ant
    jdk
    stripJavaArchivesHook
    unzip
  ];

  buildPhase = ''
    runHook preBuild
    ant -f webapp
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 lib/* -t $out/lib
    install -Dm644 dist/axis2.war -t $out/webapps
    unzip $out/webapps/axis2.war -d $out/webapps/axis2

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) tomcat;
  };

  meta = {
    description = "Web Services / SOAP / WSDL engine, the successor to the widely used Apache Axis SOAP stack";
    homepage = "https://axis.apache.org/axis2/java/core/";
    changelog = "https://axis.apache.org/axis2/java/core/release-notes/${finalAttrs.version}.html";
    maintainers = [ lib.maintainers.anthonyroussel ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
  };
})
