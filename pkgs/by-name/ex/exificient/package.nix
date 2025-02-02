{
  maven,
  fetchFromGitHub,
  lib,
  makeWrapper,
  jre,
}:

maven.buildMavenPackage rec {
  pname = "exificient";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "EXIficient";
    repo = "exificient";
    rev = "exificient-${version}";
    hash = "sha256-XrlZQf2BamYw8u1S2qQ6jV9mgyCEjBxKqPZCXMJzXmc=";
  };

  mvnHash = "sha256-/72Pi8WbKhPXu7Zb9r30znY1FHJc7FM42f7uQJqJnWo=";

  mvnParameters = "package assembly:single -Dmaven.test.skip=true";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    ls -al target/classes/com/siemens/
    mkdir -p $out/bin $out/share/exificient
    install -Dm644 target/exificient-jar-with-dependencies.jar $out/share/exificient

    makeWrapper ${jre}/bin/java $out/bin/exificient \
    --add-flags "-classpath $out/share/exificient/exificient-jar-with-dependencies.jar com.siemens.ct.exi.main.cmd.EXIficientCMD"
    runHook postInstall
  '';

  meta = {
    description = "Java implementation of the W3C Efficient Extensible Interchange (EXI) format specification";
    homepage = "http://exificient.github.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ samw ];
    mainProgram = "exificient";
  };
}
