{
  lib,
  maven,
  openjdk25,
  jre25_minimal,
  fetchFromGitHub,
  xmlstarlet,
  jq,
  makeWrapper,
}:
let
  jre = jre25_minimal.override {
    modules = [
      "java.base"
      "java.compiler"
      "java.desktop"
      "java.instrument"
      "java.net.http"
      "java.prefs"
      "java.rmi"
      "java.scripting"
      "java.security.jgss"
      "java.sql.rowset"
      "jdk.jfr"
      "jdk.management"
      "jdk.net"
      "jdk.unsupported"
    ];
  };
in
maven.buildMavenPackage rec {
  pname = "reitti";
  version = "4.0.4";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "dedicatedcode";
    repo = "reitti";
    tag = "v${version}";
    hash = "sha256-2Fx6j/88jhfiv1PHGCSM80i/F00JzIrDkJ37DEEEfHA=";
  };

  mvnHash = "sha256-AeQVaj438m/ydXe+H+IZ7ZcOkXaokng5WiBsjrOCdFo=";
  mvnJdk = openjdk25;

  mvnFlags = "-Dmaven.test.skip=true -DskipTests -Dmaven.gitcommitid.skip=true";

  nativeBuildInputs = [
    xmlstarlet
    jq
    makeWrapper
  ];

  postPatch = ''
    NS="http://maven.apache.org/POM/4.0.0"

    xmlstarlet ed -L -N x="$NS" \
      -d "//x:plugin[x:artifactId='git-commit-id-maven-plugin']" \
      -d "//x:plugin[x:artifactId='maven-surefire-plugin']" \
      -d "//x:plugin[x:artifactId='jacoco-maven-plugin']" \
      pom.xml

    rm -rf src/test

    cat > src/main/resources/git.properties <<EOF
    git.commit.id.abbrev=nix
    git.commit.time=unknown
    git.build.time=unknown
    git.tags=nix-build
    EOF

    echo '{"contributors": []}' > src/main/resources/contributors.json
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/java
    cp target/*.jar $out/share/java/reitti.jar

    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/reitti \
      --add-flags "-jar $out/share/java/reitti.jar"

    runHook postInstall
  '';

  meta = {
    description = "Personal transit tracking application";
    homepage = "https://github.com/dedicatedcode/reitti";
    license = lib.licenses.mit;
    mainProgram = "reitti";
    platforms = lib.platforms.linux;
  };
}
