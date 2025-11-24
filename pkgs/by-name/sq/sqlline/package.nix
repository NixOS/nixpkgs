{
  lib,
  maven,
  fetchFromGitHub,
  makeWrapper,
  jre,
  docbook_xml_dtd_42,
}:

maven.buildMavenPackage rec {
  pname = "sqlline";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "julianhyde";
    repo = "sqlline";
    tag = "sqlline-${version}";
    hash = "sha256-rUlGtMgTfhciQVif0KaUcuY28wh+PrHsKen8qODom24=";
  };

  mvnHash = "sha256-9qDzc6TRn9Yv3/nTATZgP6J+PTZEZCN1et/3GrRb7X4=";

  nativeBuildInputs = [
    makeWrapper
    docbook_xml_dtd_42
  ];

  mvnParameters = "-DskipTests";

  # Patch the DOCTYPE declaration in manual.xml
  postPatch = ''
    substituteInPlace src/docbkx/manual.xml \
      --replace-fail "https://docbook.org/xml/4.2/docbookx.dtd" "${docbook_xml_dtd_42}/xml/dtd/docbook/docbookx.dtd" \
      --replace-fail 'PUBLIC "-//OASIS//DTD DocBook XML V4.1.2//EN"' 'PUBLIC "-//OASIS//DTD DocBook XML V4.2//EN"'
  '';

  buildOffline = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D target/sqlline-${version}-jar-with-dependencies.jar $out/share/java/sqlline-${version}.jar
    makeWrapper ${jre}/bin/java $out/bin/sqlline \
      --add-flags "-jar $out/share/java/sqlline-${version}.jar"
    runHook postInstall
  '';

  meta = {
    description = "Shell for issuing SQL to relational databases via JDBC";
    homepage = "https://github.com/julianhyde/sqlline";
    mainProgram = "sqlline";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ taranarmo ];
  };
}
