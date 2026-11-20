{
  lib,
  stdenv,
  fetchurl,
  jdk25_headless,
  makeWrapper,
  git,
  gnused,
  gnugrep,
  gawk,
  which,
  versionCheckHook,
  nix-update-script,
  runCommand,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "copybara";
  version = "20261116";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/google/copybara/releases/download/v${finalAttrs.version}/copybara_deploy.jar";
    hash = "sha256-UMOwFXdw866OaGvovu5ZrsitUlLSWc0nfW0rjhjRsGY=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  runtimeDeps = [
    git
    gnused
    gnugrep
    gawk
    which
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java
    cp $src $out/share/java/copybara.jar

    mkdir -p $out/bin
    makeWrapper ${jdk25_headless}/bin/java $out/bin/copybara \
      --add-flags "-jar $out/share/java/copybara.jar" \
      --prefix PATH : ${lib.makeBinPath finalAttrs.runtimeDeps}

    runHook postInstall
  '';

  doInstallCheck = true;
  # java takes user.home from passwd (/var/empty in the darwin sandbox), not $HOME
  preInstallCheck = ''
    export HOME=$TMPDIR
    export JAVA_TOOL_OPTIONS="-Duser.home=$HOME"
  '';
  versionCheckKeepEnvironment = [
    "HOME"
    "JAVA_TOOL_OPTIONS"
  ];
  versionCheckProgramArg = "version";
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    updateScript = nix-update-script { };
    tests.folder-migration =
      runCommand "copybara-test-folder-migration" { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
        ''
          export HOME=$TMPDIR
          # java takes user.home from passwd, not $HOME
          export JAVA_TOOL_OPTIONS="-Duser.home=$HOME"
          mkdir origin
          echo "hello foo" > origin/file.txt
          cat > copy.bara.sky <<'SKY'
          core.workflow(
              name = "default",
              origin = folder.origin(),
              destination = folder.destination(),
              authoring = authoring.overwrite("Test <test@example.com>"),
              transformations = [core.replace(before = "foo", after = "bar")],
          )
          SKY
          copybara migrate copy.bara.sky default "$PWD/origin" --folder-dir dest
          grep -qx "hello bar" dest/file.txt
          touch $out
        '';
  };

  meta = {
    description = "Tool for transforming and moving code between repositories";
    longDescription = ''
      Copybara is a tool used internally at Google for transforming and moving
      code between repositories. It allows you to maintain code in multiple
      repositories while keeping them in sync through transformations.

      Common use cases include:
      - Importing sections of code from a confidential repository to a public repository
      - Importing code from a public repository to a confidential repository
      - Moving changes between authoritative and non-authoritative repositories
    '';
    homepage = "https://github.com/google/copybara";
    changelog = "https://github.com/google/copybara/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ shinbunbun ];
    inherit (jdk25_headless.meta) platforms;
    mainProgram = "copybara";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})
