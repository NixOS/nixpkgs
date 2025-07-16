{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_20,
  jre_headless,
  protobuf_30,
  cyclonedx-cli,
  makeWrapper,
  maven,
  nix-update-script,
  nixosTests,
}:
let
  version = "4.13.2";

  frontend = buildNpmPackage {
    pname = "dependency-track-frontend";
    inherit version;

    # TODO: pinned due to build error on node 22
    nodejs = nodejs_20;

    src = fetchFromGitHub {
      owner = "DependencyTrack";
      repo = "frontend";
      rev = version;
      hash = "sha256-HshphdOvJMRdMWYNc+nOkoFGA9Rr+N7+Gs8THBZjKTM=";
    };

    installPhase = ''
      mkdir $out
      cp -R ./dist $out/
    '';

    npmDepsHash = "sha256-u5yVJlW9LhptyHQddd1RCBgU/xNdSNX5FAmSEj6n7Ng=";
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
    hash = "sha256-4A34lt6M0M1+HPGFFqH/Ik07FBNz6pI0XYiW9rIVsOk=";
  };

  patches = [
    ./0000-remove-frontend-download.patch
    ./0001-add-junixsocket.patch
  ];

  postPatch = ''
    substituteInPlace pom.xml \
      --replace-fail '<protocArtifact>''${tool.protoc.version}</protocArtifact>' \
      "<protocCommand>${protobuf_30}/bin/protoc</protocCommand>"
  '';

  mvnJdk = jre_headless;
  mvnHash = "sha256-V0EhfPN8htR4v/KQpQ9tec6dAe/FOxBCp8cUZqL7mFo=";
  manualMvnArtifacts = [ "com.coderplus.maven.plugins:copy-rename-maven-plugin:1.0.1" ];
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

  nativeBuildInputs = [ makeWrapper ];

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
    teams = [ lib.teams.cyberus ];
    mainProgram = "dependency-track";
    inherit (jre_headless.meta) platforms;
  };
}
