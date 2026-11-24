{
  fetchurl,
  lib,
  stdenv,
  jdk,
  makeWrapper,
  coreutils,
  gnused,
  gitUpdater,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ant";
  version = "1.10.18";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "mirror://apache/ant/source/apache-ant-${finalAttrs.version}-src.tar.bz2";
    hash = "sha256-nItxykMLxRNcSRTTfJR+prjwRMgarjrf/76Pusew4YU=";
  };

  nativeBuildInputs = [ makeWrapper ];

  env.JAVA_HOME = jdk.home;

  buildPhase = ''
    runHook preBuild
    ./build.sh
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/ant
    cp -r dist/* $out/share/ant/

    # upstream dist/bin/ant honours JAVA_HOME, then falls back to `java`
    # on PATH — so add our JDK as a *fallback*, user's JDK still wins
    makeWrapper $out/share/ant/bin/ant $out/bin/ant \
      --set-default JAVA_HOME ${jdk.home} \
      --prefix PATH : ${
        lib.makeBinPath [
          jdk
          coreutils
          gnused
        ]
      }
    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgramArg = "-version";

  passthru = {
    home = "${finalAttrs.finalPackage}/share/ant";
    updateScript = gitUpdater {
      rev-prefix = "rel/";
      url = "https://gitbox.apache.org/repos/asf/ant";
    };
  };

  meta = {
    homepage = "https://ant.apache.org/";
    description = "Java-based build tool";
    mainProgram = "ant";

    longDescription = ''
      Apache Ant is a Java-based build tool.  In theory, it is kind of like
      Make, but without Make's wrinkles.

      Why another build tool when there is already make, gnumake, nmake, jam,
      and others? Because all those tools have limitations that Ant's
      original author couldn't live with when developing software across
      multiple platforms.  Make-like tools are inherently shell-based -- they
      evaluate a set of dependencies, then execute commands not unlike what
      you would issue in a shell.  This means that you can easily extend
      these tools by using or writing any program for the OS that you are
      working on.  However, this also means that you limit yourself to the
      OS, or at least the OS type such as Unix, that you are working on.

      Ant is different.  Instead of a model where it is extended with
      shell-based commands, Ant is extended using Java classes.  Instead of
      writing shell commands, the configuration files are XML-based, calling
      out a target tree where various tasks get executed.  Each task is run
      by an object that implements a particular Task interface.
    '';

    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    teams = [ lib.teams.java ];
    platforms = lib.platforms.all;
  };
})
