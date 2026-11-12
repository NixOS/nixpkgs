{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  openjdk,
  gradle_9,
  wget,
  which,
  gnused,
  gawk,
  coreutils,
  bash,
  testers,
  nixosTests,
}:
let
  gradle = gradle_9;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nextflow";
  version = "26.10.0";

  __structuredAttrs = true;

  # Suggested as an improvement, but currently breaks nix-build -A nextflow.tests
  # strictDeps = true;

  src = fetchFromGitHub {
    owner = "nextflow-io";
    repo = "nextflow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-llpZJ2XsSuGjEeVW0M/dZBqGkEI4tQT0wDAJWwJrfss=";
  };

  buildInputs = [
    bash
  ];

  nativeBuildInputs = [
    makeWrapper
    gradle
  ];

  postPatch = ''
    # Nextflow invokes the constant "/bin/bash" (not as a shebang) at
    # several locations so we fix that globally. However, when running inside
    # a container, we actually *want* "/bin/bash". Thus the global fix needs
    # to be reverted for this specific use case.
    #
    # Two code paths need the revert:
    #   1. launcher (the command that invokes .command.run)
    #   2. trace_cmd (the command inside .command.run's nxf_trace function
    #      that invokes .command.sh — see command-trace.txt template)
    # Without the trace_cmd revert, trace+docker fails because the trace
    # function tries to call /nix/store/.../bash inside the container.
    # See https://github.com/NixOS/nixpkgs/issues/350183
    substituteInPlace modules/nextflow/src/main/groovy/nextflow/executor/BashWrapperBuilder.groovy \
      --replace-fail "['/bin/bash'," "['${bash}/bin/bash'," \
      --replace-fail '? "/bin/bash"' '? "'${bash}'/bin/bash"' \
      --replace-fail "if( containerBuilder ) {" "if( containerBuilder ) {
                launcher = launcher.replaceFirst(\"/nix/store/.*/bin/bash\", \"/bin/bash\")" \
      --replace-fail "binding.trace_cmd = getTraceCommand(interpreter)" \
        "binding.trace_cmd = containerBuilder != null ? getTraceCommand(interpreter).replaceFirst(\"/nix/store/.*/bin/bash\", \"/bin/bash\") : getTraceCommand(interpreter)"

    # Also need to prevent foojay from trying to download OpenJDK:
    substituteInPlace settings.gradle \
      --replace-fail 'id("org.gradle.toolchains.foojay-resolver-convention") version "1.0.0"' ""
  '';

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };
  __darwinAllowLocalNetworking = true;

  # During the build, some additional dependencies are downloaded ("detached
  # configuration"). We thus need to run a full build on instead of the default
  # one.
  # See https://github.com/NixOS/nixpkgs/pull/339197#discussion_r1747749061
  gradleUpdateTask = "pack";

  gradleFlags = [
    # The installer attempts to copy a final JAR to $HOME/.nextflow/...
    "-Duser.home=\$TMPDIR"

    # nf-* dependencies will fail to compile unless they can find OpenJDK:
    "-Dorg.gradle.java.home=${openjdk}"
  ];

  preBuild = ''
    # See Makefile (`make pack`)
    export BUILD_PACK=1
  '';
  gradleBuildTask = "pack";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 build/releases/nextflow-${finalAttrs.version}-dist $out/bin/nextflow

    runHook postInstall
  '';

  # --run is used instead of --set to avoid makeWrapper's single-quote escaping,
  # which prevents $USER from expanding at runtime. See #192396
  postFixup = ''
    wrapProgram $out/bin/nextflow \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gawk
          gnused
          wget
          which
        ]
      } \
      --set JAVA_HOME ${openjdk.home} \
      --run 'export NXF_OPTS="-Duser.name=''$USER''${NXF_OPTS:+ ''$NXF_OPTS}"'
  '';

  passthru.tests.default = nixosTests.nextflow;
  # versionCheckHook doesn't work as of 2024-09-23.
  # See https://github.com/NixOS/nixpkgs/pull/339197#issuecomment-2363495060
  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "env HOME=$TMPDIR nextflow -version";
  };

  meta = {
    description = "DSL for data-driven computational pipelines";
    longDescription = ''
      Nextflow is a bioinformatics workflow manager that enables the development of portable and reproducible workflows.

      It supports deploying workflows on a variety of execution platforms including local, HPC schedulers, AWS Batch, Google Cloud Life Sciences, and Kubernetes.

      Additionally, it provides support for manage your workflow dependencies through built-in support for Conda, Docker, Singularity, and Modules.
    '';
    homepage = "https://www.nextflow.io/";
    changelog = "https://github.com/nextflow-io/nextflow/releases";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      Etjean
      mulatta
      David-Moody
      pjones
    ];
    mainProgram = "nextflow";
    platforms = lib.platforms.unix;
  };
})
