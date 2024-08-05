{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  jre_headless,
  cyclonedx-cli,
  makeWrapper,
  maven,
  nix-update-script,
  nixosTests,
}:
let
  version = "4.11.5";

  frontend = buildNpmPackage {
    pname = "dependency-track-frontend";
    inherit version;

    src = fetchFromGitHub {
      owner = "DependencyTrack";
      repo = "frontend";
      rev = version;
      hash = "sha256-YJ5D7hTLlaAgOXz4nT+eh1n5/OulHCsPCN1LAB+1J8M=";
    };

    npmDepsHash = "sha256-LHK222OzjVHYP4/cVpWfoFSFbfbEt5FNTJry5te3XvQ=";
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
    hash = "sha256-iVJidl1NbgTj5+DiU8MKJy0lMo608cfA2oMcrypLadI=";
  };

  patches = [
    ./0000-remove-frontend-download.patch
    ./0001-add-junixsocket.patch
  ];

  mvnJdk = jre_headless;
  mvnHash = "sha256-o5+R9dWRMSDRGvz/7v7KPM9VPpO6wu43kSpGs9zGfuM=";
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
    tests = {
      inherit (nixosTests) dependency-track;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Intelligent Component Analysis platform that allows organizations to identify and reduce risk in the software supply chain";
    homepage = "https://github.com/DependencyTrack/dependency-track";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ xanderio ];
    mainProgram = "dependency-track";
    inherit (jre_headless.meta) platforms;
  };
}
