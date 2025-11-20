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
  version = "4.13.6";

  frontend = buildNpmPackage {
    pname = "dependency-track-frontend";
    inherit version;

    # TODO: pinned due to build error on node 22
    nodejs = nodejs_20;

    src = fetchFromGitHub {
      owner = "DependencyTrack";
      repo = "frontend";
      rev = version;
      hash = "sha256-SSnbmAFXQwxAZQzMZeDzf/ebbWUVRICAs1msFXMMi98=";
    };

    installPhase = ''
      mkdir $out
      cp -R ./dist $out/
    '';

    npmDepsHash = "sha256-2VK3LOqUxOJaR8cUuINhrhMkvHGyUr206RJR18NCvUo=";
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
    hash = "sha256-EL0Yd8pfTG8/DlY9A3F0lRuPl/wU2/LyACclzttrsjw=";
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
  mvnHash = "sha256-HZK/o/RMbMj7OUfucizO5/LpJhwNhHfwbyvUOcO13dA=";
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
