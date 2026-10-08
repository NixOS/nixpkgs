{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchpatch2,
  jre_headless,
  protobuf_30,
  xmlstarlet,
  cyclonedx-cli,
  makeWrapper,
  maven,
  nix-update-script,
  nixosTests,
}:
let
  version = "4.14.2";

  frontend = buildNpmPackage {
    pname = "dependency-track-frontend";
    inherit version;

    src = fetchFromGitHub {
      owner = "DependencyTrack";
      repo = "frontend";
      tag = version;
      hash = "sha256-/MH1YjEJdRjYjenkzOcp7oytudsJcinPbc9OAGFnI/Q=";
    };

    installPhase = ''
      mkdir $out
      cp -R ./dist $out/
    '';

    patches = [
      (fetchpatch2 {
        url = "https://github.com/DependencyTrack/frontend/pull/1575.patch?full_index=1";
        hash = "sha256-Wo+6yXa/8jB/pph0DTNsFz6lK3sedvro+7yvLSKes9c=";
      })
    ];

    npmDepsHash = "sha256-md+PGEC1/Kl2MQhhYldSErcsDSefbPvwVDsw0Yklq1E=";
    forceGitDeps = true;
    makeCacheWritable = true;

    # The prepack script runs the build script, which we'd rather do in the build phase.
    npmPackFlags = [ "--ignore-scripts" ];
  };
in

maven.buildMavenPackage rec {
  inherit version;
  pname = "dependency-track";

  src = fetchFromGitHub {
    owner = "DependencyTrack";
    repo = "dependency-track";
    tag = version;
    hash = "sha256-9EPjIm2VOmt1FEiPoJtwNHoKZcewO0kJgBSc9fnUXeI=";
  };

  postPatch = ''
    # update to version 5.1.3 to fix NullPointer and specify protoc path
    xmlstarlet ed --inplace -N x=http://maven.apache.org/POM/4.0.0 \
    --update '//x:plugin[x:artifactId="protobuf-maven-plugin"]/x:version' -v "5.1.3" \
    --delete '//x:plugin[x:artifactId="protobuf-maven-plugin"]/x:configuration/x:protoc' \
    --subnode '//x:plugin[x:artifactId="protobuf-maven-plugin"]/x:configuration' -t elem -n protoc -v "" \
    --var protoc '$prev' \
    --insert '$protoc' -t attr -n kind -v "path" \
    --subnode '$protoc' -t elem -n name -v "protoc" \
    pom.xml

    # remove frontend related tasks
    xmlstarlet ed --inplace -N x=http://maven.apache.org/POM/4.0.0 \
    --delete '//x:execution[x:id="frontend-download"]' \
    --delete '//x:execution[x:id="frontend-extract"]' \
    --delete '//x:execution[x:id="frontend-resource-deploy"]' \
    pom.xml

    # add junixsocket to enable unixsocket connection to postgres
    xmlstarlet ed --inplace -N x=http://maven.apache.org/POM/4.0.0 \
    --subnode '/x:project/x:dependencies' -t elem -n dependency -v "" \
    --var dependency '$prev' \
    --subnode '$dependency' -t elem -n groupId -v "com.kohlschutter.junixsocket" \
    --subnode '$dependency' -t elem -n artifactId -v "junixsocket-core" \
    --subnode '$dependency' -t elem -n version -v "2.10.0" \
    --subnode '$dependency' -t elem -n type -v "pom" \
    pom.xml
  '';

  mvnJdk = jre_headless;
  mvnHash = "sha256-pshUDIPPGGGzxg5WJXC3mjnqGXn8HVowFCb2l5f6zjA=";
  manualMvnArtifacts = [
    "com.coderplus.maven.plugins:copy-rename-maven-plugin:1.0.1"
    # added to saticfy protobuf compiler plugin dependency resolving
    "jakarta.el:jakarta.el-api:5.0.1"
    "com.fasterxml.jackson.module:jackson-module-jakarta-xmlbind-annotations:2.19.1"
    "com.fasterxml.jackson.dataformat:jackson-dataformat-xml:2.21.0"
    "com.fasterxml.jackson.dataformat:jackson-dataformat-yaml:2.18.3"
    "com.fasterxml.jackson.datatype:jackson-datatype-jsr310:2.21.2"
    "io.micrometer:micrometer-core:1.16.0"
    "io.micrometer:micrometer-observation:1.16.0"
  ];
  buildOffline = true;

  mvnDepsParameters = lib.escapeShellArgs [
    "-Dmaven.test.skip=true"
    "-P enhance"
    "-P embedded-jetty"
  ];

  mvnParameters = lib.escapeShellArgs [
    "-Dmaven.test.skip=true"
    "-P enhance"
    "-P embedded-jetty"
    "-Dservices.bom.merge.skip=false"
    "-Dlogback.configuration.file=${src}/src/main/docker/logback.xml"
    "-Dcyclonedx-cli.path=${lib.getExe cyclonedx-cli}"
  ];

  afterDepsSetup = ''
    mvn cyclonedx:makeBom -Dmaven.repo.local=$mvnDeps/.m2 \
      org.codehaus.mojo:exec-maven-plugin:exec@merge-services-bom
  '';

  doCheck = false;

  nativeBuildInputs = [
    makeWrapper
    xmlstarlet
    protobuf_30
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 target/dependency-track-*.jar $out/share/dependency-track/dependency-track.jar
    makeWrapper ${jre_headless}/bin/java $out/bin/dependency-track \
      --add-flags "-jar $out/share/dependency-track/dependency-track.jar"

    runHook postInstall
  '';

  passthru = {
    inherit frontend;
    tests = {
      inherit (nixosTests) dependency-track;
    };
    updateScript = nix-update-script {
      extraArgs = [
        "-s"
        "frontend"
      ];
    };
  };

  meta = {
    description = "Intelligent Component Analysis platform that allows organizations to identify and reduce risk in the software supply chain";
    homepage = "https://github.com/DependencyTrack/dependency-track";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      e1mo
      xanderio
    ];
    mainProgram = "dependency-track";
    inherit (jre_headless.meta) platforms;
  };
}
