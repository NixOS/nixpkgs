{
  fetchurl,
  lib,
  stdenv,
  jdk,
  jdk8,
  callPackage,
  fetchMavenArtifact,
  coreutils,
  gitUpdater,
  versionCheckHook,
  runCommand,
  testers,
  writeText,
}:

stdenv.mkDerivation (
  finalAttrs:
  let
    # Libraries for building Ant's optional tasks, fetched from Maven
    # Central like upstream's fetch.xml does.  Without them the optional
    # task classes are not compiled and consumers of those tasks (e.g.
    # jogl needs the antlr task) fail at build time.
    optionalLibs = callPackage ./optional-libs.nix { };
  in
  {
    pname = "ant";
    version = "1.10.18";
    __structuredAttrs = true;
    strictDeps = true;

    src = fetchurl {
      url = "mirror://apache/ant/source/apache-ant-${finalAttrs.version}-src.tar.bz2";
      hash = "sha256-nItxykMLxRNcSRTTfJR+prjwRMgarjrf/76Pusew4YU=";
    };

    env.JAVA_HOME = jdk.home;

    buildPhase = ''
      runHook preBuild
      cp ${toString (map (l: l.passthru.jar) optionalLibs)} lib/optional/
      ./build.sh
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin $out/share/ant
      cp -r dist/* $out/share/ant/

      # Do not use upstream's bin/ant launcher: it prefers
      # $JAVA_HOME/jre/bin/java when it exists, which is the case for
      # openjdk < 11 in nixpkgs (the jre output is linked into the JDK).
      # Running that JVM makes java.home resolve to the JRE, where the
      # launcher cannot find tools.jar, so every <javac> task fails with
      # "Unable to find a javac compiler".  The launcher below always
      # uses the JVM from $JAVA_HOME/bin instead.
      cat > $out/bin/ant <<EOF
      #! ${stdenv.shell} -e

      ANT_HOME=$out/share/ant

      # Find the JDK by looking for javac.  As a fall-back, find the
      # JRE by looking for java.  The latter allows just the JRE to be
      # used with (say) ECJ as the compiler.  Finally, allow the GNU
      # JVM.
      if [ -z "\''${JAVA_HOME-}" ]; then
          for i in javac java gij; do
              if p="\$(type -p \$i)"; then
                  export JAVA_HOME="\$(${coreutils}/bin/dirname \$(${coreutils}/bin/dirname \$(${coreutils}/bin/readlink -f \$p)))"
                  break
              fi
          done
          if [ -z "\''${JAVA_HOME-}" ]; then
              # No JDK or JRE on PATH: fall back to the JDK that ant
              # itself was built with, so ant still runs for tasks that
              # do not need a compiler.
              export JAVA_HOME=${jdk.home}
          fi
      fi

      if [ -z \$NIX_JVM ]; then
          if [ -e \$JAVA_HOME/bin/java ]; then
              NIX_JVM=\$JAVA_HOME/bin/java
          elif [ -e \$JAVA_HOME/bin/gij ]; then
              NIX_JVM=\$JAVA_HOME/bin/gij
          else
              NIX_JVM=java
          fi
      fi

      LOCALCLASSPATH="\$ANT_HOME/lib/ant-launcher.jar\''${LOCALCLASSPATH:+:}\$LOCALCLASSPATH"

      if [ -n "\$ANT_LIB" ]; then
          ANT_LIB_ARG="-Dant.library.dir=\$ANT_LIB"
      fi

      exec \$NIX_JVM \$NIX_ANT_OPTS \$ANT_OPTS -classpath "\$LOCALCLASSPATH" \\
          -Dant.home=\$ANT_HOME \''${ANT_LIB_ARG:+"\$ANT_LIB_ARG"} \\
          org.apache.tools.ant.launch.Launcher \$NIX_ANT_ARGS \$ANT_ARGS \\
          -cp "\$CLASSPATH" "\$@"
      EOF

      chmod +x $out/bin/ant
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
      tests.javac-jdk8 =
        # Regression test for the ant launcher: it must run the JVM from
        # $JAVA_HOME/bin.  Upstream's bin/ant prefers $JAVA_HOME/jre/bin/java
        # when it exists, which is the case for all openjdk < 11 in nixpkgs
        # (their jre output is linked into the JDK).  Running that JVM makes
        # java.home resolve into the JRE, where the launcher cannot find
        # tools.jar, so <javac> fails with "Unable to find a javac compiler".
        testers.testEqualContents {
          assertion = "can compile and run a Java file with the JDK given via JAVA_HOME";
          expected = writeText "expected" "Hello from ant!\n";
          actual =
            runCommand "actual"
              {
                nativeBuildInputs = [ finalAttrs.finalPackage ];
                src = ./tests/javac-jdk8;
                env.JAVA_HOME = jdk8.home;
              }
              ''
                cp -a $src/* .
                ant
                ${jdk8.jre}/bin/java -cp build Hello > $out
              '';
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
  }
)
