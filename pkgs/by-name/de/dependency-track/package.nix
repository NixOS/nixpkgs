{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  jdk25_headless,
  protobuf_30,
  xmlstarlet,
  makeWrapper,
  maven,
  nix-update-script,
  nixosTests,
}:
let
  version = "5.0.1";

  jdk = jdk25_headless;

  frontend = buildNpmPackage {
    pname = "dependency-track-frontend";
    inherit version;

    src = fetchFromGitHub {
      owner = "DependencyTrack";
      repo = "frontend";
      rev = version;
      hash = "sha256-1M4z4kLY5kQW00Y9aSZkkayUzQGS0oFgCKApl/veQYM=";
    };

    installPhase = ''
      mkdir $out
      cp -R ./dist $out/
    '';

    npmDepsHash = "sha256-XxERLmAoRJUOlMcC9zRueS+ZlTXiVM87irXeZ8BIFNY=";
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
    rev = version;
    hash = "sha256-txH7n77FBwtyJ0W+ecKyChFulDiMZUC/KMCCxziHPEg=";
  };

  postPatch = ''
    # specify protoc path
    xmlstarlet ed --inplace -N x=http://maven.apache.org/POM/4.0.0 \
    --delete '//x:plugin[x:artifactId="protobuf-maven-plugin"]/x:configuration/x:protoc' \
    --subnode '//x:plugin[x:artifactId="protobuf-maven-plugin"]/x:configuration' -t elem -n protoc -v "" \
    --var protoc '$prev' \
    --insert '$protoc' -t attr -n kind -v "path" \
    --subnode '$protoc' -t elem -n name -v "protoc" \
    pom.xml

    # remove bom related tasks, this requieres maven online mode
    xmlstarlet ed --inplace -N x=http://maven.apache.org/POM/4.0.0 \
    --delete '//x:execution[x:id="deploy-bom"]' \
    apiserver/pom.xml

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

  mvnJdk = jdk;
  mvnHash = "sha256-kYKj6VLLAAMqqe74Ca6qkS2j0f9dU6OtHueenFOOvPc=";
  manualMvnArtifacts = [
    "org.apache.maven.plugins:maven-antrun-plugin:3.1.0"
    "org.apache.maven.plugins:maven-assembly-plugin:3.7.1"
    "org.apache.maven.plugins:maven-surefire-report-plugin:3.5.5"
    "org.apache.maven.plugins:maven-release-plugin:3.3.1"
    "org.eclipse.microprofile.config:microprofile-config-api:3.1.1-RC1"
  ];
  buildOffline = true;

  mvnDepsParameters = lib.escapeShellArgs [
    "-Dmaven.test.skip=true"
  ];

  mvnParameters = lib.escapeShellArgs [
    "-Dmaven.test.skip=true"
    # BOM generation requieres maven online mode
    "-Dservices.bom.merge.skip=true"
  ];

  doCheck = false;

  nativeBuildInputs = [
    makeWrapper
    xmlstarlet
    protobuf_30
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 apiserver/target/dependency-track-apiserver.jar $out/share/dependency-track/dependency-track.jar
    makeWrapper ${jdk}/bin/java $out/bin/dependency-track \
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
    inherit (jdk.meta) platforms;
  };
}
