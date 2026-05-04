{
  lib,
  maven,
  openjdk25,
  fetchFromGitHub,
  xmlstarlet,
  jq,
  makeWrapper,
}:
maven.buildMavenPackage {
  __structuredAttrs = true;

  pname = "reitti";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "dedicatedcode";
    repo = "reitti";
    rev = "54291e7d71dc9cc256f22a3c08176974c314d315";
    hash = "sha256-ybRArA9MzQRwF/WuC0PLr5n4pfte2kw1hluwezSR3os=";
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
    makeWrapper ${openjdk25}/bin/java $out/bin/reitti \
      --add-flags "-jar $out/share/java/reitti.jar"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A personal transit tracking application";
    homepage = "https://github.com/dedicatedcode/reitti";
    license = licenses.mit;
    mainProgram = "reitti";
    platforms = platforms.linux;
  };
}
