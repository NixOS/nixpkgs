{
  lib,
  fetchFromGitHub,
  graalvmPackages,
  maven_4,
  versionCheckHook,
  nix-update-script,
}:
maven_4.buildMavenPackage (finalAttrs: {
  pname = "jfmt";
  version = "0.2.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "bmarwell";
    repo = "jfmt";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-wynVkOUFS8MMBp+Go7VUA3j4xsb1UJDeNR2PAmkZAYA=";
  };
  mvnHash = "sha256-JOo+tcTn4w/Vy5t2HK+MSc/DCHYGy0Ja3oY+nZJaRt4=";

  # picocli-codegen 4.7.7 registers VersionProvider's methods and constructors but not
  # its @Spec field, and GraalVM >= 25.2 turns unregistered field access into a fatal
  # MissingReflectionRegistrationError, so the binary dies on startup. Register it here.
  # Reported upstream as https://github.com/bmarwell/jfmt/issues/260; drop this once fixed.
  postPatch = ''
    cat > cli/src/main/resources/META-INF/native-image/io.github.bmarwell.jfmt/jfmt/reachability-metadata.json <<EOF
    {
      "reflection": [
        {
          "type": "io.github.bmarwell.jfmt.VersionProvider",
          "fields": [{ "name": "commandSpec" }]
        }
      ]
    }
    EOF
  '';

  # GraalVM CE with musl libc support; native-image is at $JAVA_HOME/bin/native-image
  # and the wrapper provides musl-gcc and musl C library paths automatically.
  mvnJdk = graalvmPackages.graalvm-ce-musl;
  doCheck = false;
  # -Pnative activates native-maven-plugin (runs native-image during package phase).
  # The dist-linux profile auto-activates on Linux and adds --static --libc=musl,
  # which works with graalvm-ce-musl's musl toolchain wrapper.
  # Spotless is skipped to avoid downloading the Eclipse JDT formatter at build time.
  mvnParameters = lib.escapeShellArgs [
    "-Djreleaser.reproducible=true"
    "-Dspotless.skip=true"
    "-Pnative"
    "-pl"
    "cli"
    "-am"
  ];

  nativeBuildInputs = [ graalvmPackages.graalvm-ce-musl ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    # The native-maven-plugin outputs the binary named after $${project.artifactId}-$${project.version}.
    # Exclude JARs and ZIPs created by maven-assembly-plugin in the same directory.
    find cli/target -maxdepth 1 -type f -perm /0111 -name 'jfmt*' \
    -exec install -m755 {} $out/bin/jfmt \;
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };
  meta = {
    description = "jfmt is an opinionated java source code formatter for the command line ";
    homepage = "https://github.com/bmarwell/jfmt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ britter ];
    mainProgram = "jfmt";
    platforms = lib.platforms.linux;
  };
})
