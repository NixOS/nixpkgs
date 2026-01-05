{
  fetchurl,
  lib,
  stdenv,
  coreutils,
  makeWrapper,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ant";
  version = "1.10.15";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchurl {
    url = "mirror://apache/ant/binaries/apache-ant-${finalAttrs.version}-bin.tar.bz2";
    hash = "sha256-h/SNGLoRwRVojDfvl1g+xv+J6mAz+J2BimckjaRxDEs=";
  };

  installPhase = ''
    mkdir -p $out/bin $out/share/ant
    mv * $out/share/ant/

    # Get rid of the manual (35 MiB).  Maybe we should put this in a
    # separate output.  Keep the antRun script since it's vanilla sh
    # and needed for the <exec/> task (but since we set ANT_HOME to
    # a weird value, we have to move antRun to a weird location).
    # Get rid of the other Ant scripts since we provide our own.
    mv $out/share/ant/bin/antRun $out/bin/
    rm -rf $out/share/ant/{manual,bin,WHATSNEW}
    mkdir $out/share/ant/bin
    mv $out/bin/antRun $out/share/ant/bin/

    cat >> $out/bin/ant <<EOF
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
            echo "\$0: cannot find the JDK or JRE" >&2
            exit 1
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

    exec \$NIX_JVM \$NIX_ANT_OPTS \$ANT_OPTS -classpath "\$LOCALCLASSPATH" \
        -Dant.home=\$ANT_HOME -Dant.library.dir="\$ANT_LIB" \
        org.apache.tools.ant.launch.Launcher \$NIX_ANT_ARGS \$ANT_ARGS \
        -cp "\$CLASSPATH" "\$@"
    EOF

    chmod +x $out/bin/ant
  '';

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
