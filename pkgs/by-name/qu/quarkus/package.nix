{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  git,
  makeWrapper,
  jdk,
  maven,
  testers,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "quarkus-cli";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "quarkusio";
    repo = "quarkus";
    tag = finalAttrs.version;
    hash = "sha256-Or27DwZcWznenh6e0YI2w9tPKNBNLie9fEZe+IvJ5mQ=";
  };

  nativeBuildInputs = [
    git
    jdk
    makeWrapper
    maven
  ];

  env = {
    JAVA_HOME = jdk;
    MAVEN_OPTS = "-Xmx4g";
  };

  # Quarkus resolves deployment dependencies during the reactor build.
  passthru.mavenDependencies = finalAttrs.finalPackage.overrideAttrs {
    pname = "quarkus-cli-maven-dependencies";
    preBuild = "";
    mavenFlags = "";
    installPhase = ''
      runHook preInstall

      mv "$TMPDIR/maven-repository" "$out"
      # Remove locally installed reactor artifacts using Maven's repository tracking files.
      find "$out" -name _remote.repositories -print0 |
        while IFS= read -r -d "" trackingFile; do
          while IFS= read -r artifact; do
            rm -f "''${trackingFile%/*}/$artifact"
          done < <(sed -n 's/^\([^#].*\)>=$/\1/p' "$trackingFile")
          sed -i -e '/^#/d' -e '/>=$/d' "$trackingFile"
        done
      find "$out" -type f \( -name '*.lastUpdated' -o -name resolver-status.properties \
        -o -name maven-metadata-local.xml \) -delete
      find "$out" -name _remote.repositories -empty -delete
      find "$out" -type d -empty -delete

      runHook postInstall
    '';
    dontFixup = true;
    outputHashMode = "recursive";
    outputHash = "sha256-wp2G/byiCS6/qx4gtLs62d8bHbxCvBXsMSDteqxLVH0=";
  };


  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  preBuild = ''
    cp -R ${finalAttrs.finalPackage.mavenDependencies} "$TMPDIR/maven-repository"
    chmod -R u+w "$TMPDIR/maven-repository"
  '';

  mavenFlags = "--offline";

  buildPhase = ''
    runHook preBuild

    export HOME="$TMPDIR/home"
    mkdir -p "$HOME"
    # The RESTEasy Byte Buddy plugin loads build support outside Maven's dependency graph.
    mvn --batch-mode --no-transfer-progress $mavenFlags \
      -Dmaven.repo.local="$TMPDIR/maven-repository" \
      -Dquickly -Dno-build-cache \
      -pl devtools/cli,:resteasy-reactive-build-support -am install

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 devtools/cli/target/quarkus-cli-${finalAttrs.version}-runner.jar \
      "$out/lib/quarkus-cli-${finalAttrs.version}-runner.jar"

    makeWrapper ${jdk}/bin/java "$out/bin/quarkus" \
      --add-flags "-jar $out/lib/quarkus-cli-${finalAttrs.version}-runner.jar"

    runHook postInstall
  '';

  meta = {
    description = "Kubernetes-native Java framework tailored for GraalVM and HotSpot, crafted from best-of-breed Java libraries and standards";
    homepage = "https://quarkus.io";
    changelog = "https://github.com/quarkusio/quarkus/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.vinetos ];
    platforms = lib.platforms.all;
    mainProgram = "quarkus";
  };
})
