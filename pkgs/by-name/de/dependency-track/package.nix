{
  lib,
  maven,
  fetchFromGitHub,
  jdk25_headless,
  protobuf_36,
  cyclonedx-cli,
  jq,
  writeShellApplication,
  junixsocket-common,
  junixsocket-native-common,
  makeWrapper,
  callPackage,
  nix-update-script,
  nixosTests,
}:

let
  # `cyclonedx merge` adds the current time and a random serial number.
  # Keep the serial of the BOM it merges into, which cyclonedx-maven-plugin derives from the project.
  cyclonedx-merge = writeShellApplication {
    name = "cyclonedx-merge";
    runtimeInputs = [
      cyclonedx-cli
      jq
    ];
    text = ''
      bom=''${*: -1}
      serial=$(jq -r .serialNumber "$bom")
      cyclonedx "$@"
      jq --arg serial "$serial" '.serialNumber = $serial | del(.metadata.timestamp)' "$bom" > "$bom.tmp"
      mv "$bom.tmp" "$bom"
    '';
  };
in
maven.buildMavenPackage (finalAttrs: {
  pname = "dependency-track";
  version = "5.2.1";

  src = fetchFromGitHub {
    owner = "DependencyTrack";
    repo = "dependency-track";
    tag = finalAttrs.version;
    hash = "sha256-3TmCxHhbz7oB4EwwupUvX0oWYuaMPriGurQ7K4ilCQ0=";
  };

  # Use protoc from nixpkgs instead of the prebuilt binary from Maven Central.
  # protobuf-java rejects code from a newer protoc.
  postPatch = ''
    grep -q '<lib.protobuf-java.version>4.${protobuf_36.version}<' pom.xml \
      || { echo "protobuf_36 ${protobuf_36.version} does not match protobuf-java in pom.xml"; exit 1; }
    substituteInPlace pom.xml \
      --replace-fail '<protoc>''${lib.protobuf-java.version}</protoc>' '<protoc>PATH</protoc>'

    # Pin the build timestamp, and derive the build UUID from $out so it still changes with every input.
    # Dependency-Track re-seeds its default objects whenever the UUID changes.
    timestamp=$(date -ud "@$SOURCE_DATE_EPOCH" +%FT%TZ)
    uuid=$(sha256sum <<< "$out" | sed -E 's/^(.{8})(.{4})(.{4})(.{4})(.{12}).*/\1-\2-\3-\4-\5/')
    substituteInPlace apiserver/src/main/resources/application.version \
      --replace-fail 'timestamp=''${maven.build.timestamp}' "timestamp=$timestamp" \
      --replace-fail 'uuid=''${project.build.uuid}' "uuid=$uuid"
    substituteInPlace alpine/alpine-server/src/main/resources/alpine.version \
      --replace-fail 'timestamp=''${timestamp}' "timestamp=$timestamp" \
      --replace-fail 'uuid=''${project.build.uuid}' "uuid=$uuid"
  '';

  mvnJdk = jdk25_headless;
  # cyclonedx-maven-plugin skips the SBOM in offline mode. The sandbox still blocks network access.
  mvnOffline = false;
  mvnHash = "sha256-p+fwRt31P2BcOMN+1N0TB5tMF8jEh++y53H+TTHVZTo=";

  # Upstream's release build uses these flags.
  mvnParameters = lib.escapeShellArgs [
    "-Pquick"
    "-Dmaven.build.cache.enabled=false"
    "-Dservices.bom.merge.skip=false"
    "-Dcyclonedx-cli.path=${lib.getExe cyclonedx-merge}"
  ];

  doCheck = false;

  nativeBuildInputs = [
    finalAttrs.mvnJdk
    makeWrapper
    protobuf_36
  ];

  # Upstream's container image uses this layout and a JRE trimmed with jlink.
  # junixsocket lets the JDBC driver connect to PostgreSQL over its Unix socket.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/dependency-track
    pushd apiserver/target
    mv lib-internal/* lib/
    ln -s ${junixsocket-common}/share/java/*.jar ${junixsocket-native-common}/share/java/*.jar lib/
    bash ../src/main/docker/create-jre.sh -i dependency-track-apiserver.jar -o $out/share/dependency-track/jre
    cp -rP -t $out/share/dependency-track dependency-track-apiserver.jar lib
    popd
    cp -t $out/share/dependency-track support/v4-migrator/target/v4-migrator.jar

    makeWrapper $out/share/dependency-track/jre/bin/java $out/bin/dependency-track \
      --add-flag --add-opens=java.base/java.util.concurrent=ALL-UNNAMED \
      --add-flag --enable-native-access=ALL-UNNAMED \
      --add-flag --sun-misc-unsafe-memory-access=allow \
      --add-flag -Djdk.http.auth.tunneling.disabledSchemes= \
      --add-flag -cp \
      --add-flag "$out/share/dependency-track/dependency-track-apiserver.jar:$out/share/dependency-track/lib/*" \
      --add-flag org.dependencytrack.Application

    makeWrapper $out/share/dependency-track/jre/bin/java $out/bin/dependency-track-v4-migrator \
      --add-flag --enable-native-access=ALL-UNNAMED \
      --add-flag -cp \
      --add-flag "$out/share/dependency-track/v4-migrator.jar:${junixsocket-common}/share/java/*:${junixsocket-native-common}/share/java/*" \
      --add-flag org.dependencytrack.v4migrator.V4Migrator

    runHook postInstall
  '';

  passthru = {
    frontend = callPackage ./frontend.nix { dependency-track = finalAttrs.finalPackage; };
    tests = { inherit (nixosTests) dependency-track; };
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "frontend"
      ];
    };
  };

  meta = {
    description = "Intelligent Component Analysis platform that allows organizations to identify and reduce risk in the software supply chain";
    homepage = "https://dependencytrack.org/";
    changelog = "https://github.com/DependencyTrack/dependency-track/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      e1mo
      xanderio
    ];
    mainProgram = "dependency-track";
    inherit (finalAttrs.mvnJdk.meta) platforms;
  };
})
