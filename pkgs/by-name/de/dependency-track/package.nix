{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  jre_headless,
  protobuf,
  cyclonedx-cli,
  makeWrapper,
  maven,
  nix-update-script,
  nixosTests,
}:
let
  version = "4.12.2";

  frontend = buildNpmPackage {
    pname = "dependency-track-frontend";
    inherit version;

    src = fetchFromGitHub {
      owner = "DependencyTrack";
      repo = "frontend";
      rev = version;
      hash = "sha256-M7UtyhIuEi6ebkjO8OM0VVi8LQ+VqeVIzBgQwIzSAzg=";
    };

    npmDepsHash = "sha256-ZU5D3ZXLaZ1m2YP6uZmpzahP2JQPL9tdOHOyN9fp/XA=";
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
    hash = "sha256-wn4HnOFhV02oq66LwBIOVzU+ehXemCuzOWcDASG/47c=";
  };

  patches = [
    ./0000-remove-frontend-download.patch
    ./0001-add-junixsocket.patch
  ];

  postPatch = ''
    substituteInPlace pom.xml \
      --replace-fail '<protocArtifact>''${tool.protoc.version}</protocArtifact>' \
      "<protocCommand>${protobuf}/bin/protoc</protocCommand>"
  '';

  mvnJdk = jre_headless;
  mvnHash = "sha256-x1/b8LoXyGxCQiu7QB60XSpiufTk/y4492mOraFnRKY=";
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
    "-P bundle-ui"
    "-Dservices.bom.merge.skip=false"
    "-Dlogback.configuration.file=${src}/src/main/docker/logback.xml"
    "-Dcyclonedx-cli.path=${lib.getExe cyclonedx-cli}"
  ];

  preBuild = ''
    mkdir -p frontend
    cp -r ${frontend}/lib/node_modules/@dependencytrack/frontend/dist frontend/
  '';

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
    # passthru for nix-update
    inherit (frontend) npmDeps;
    tests = {
      inherit (nixosTests) dependency-track;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Intelligent Component Analysis platform that allows organizations to identify and reduce risk in the software supply chain";
    homepage = "https://github.com/DependencyTrack/dependency-track";
    license = lib.licenses.asl20;
    maintainers = lib.teams.cyberus.members;
    mainProgram = "dependency-track";
    inherit (jre_headless.meta) platforms;
  };
}
