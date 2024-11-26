{
  fetchurl,
  lib,
  stdenv,
  jre,
  makeWrapper,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ant";
  version = "1.10.15";

  buildInputs = [ jre ];

  nativeBuildInputs = [ makeWrapper ];

  src = fetchurl {
    url = "mirror://apache/ant/binaries/apache-ant-${finalAttrs.version}-bin.tar.bz2";
    hash = "sha256-h/SNGLoRwRVojDfvl1g+xv+J6mAz+J2BimckjaRxDEs=";
  };

  contrib = fetchurl {
    url = "mirror://sourceforge/ant-contrib/ant-contrib-1.0b3-bin.tar.bz2";
    sha256 = "1l8say86bz9gxp4yy777z7nm4j6m905pg342li1aphc14p5grvwn";
  };

  installPhase = ''
    mkdir -p $out/share/ant
    mv * $out/share/ant/

    # Get rid of the manual (35 MiB).  Maybe we should put this in a
    # separate output.
    rm -rf $out/share/ant/{manual,WHATSNEW}

    # Link Ant's special $ANT_HOME/bin to the standard /bin location
    ln -s $out/share/ant/bin $out

    # Install ant-contrib.
    unpackFile $contrib
    cp -p ant-contrib/ant-contrib-*.jar $out/share/ant/lib/

    # Wrap the wrappers.
    for wrapper in ant runant.py runant.pl; do
      wrapProgram "$out/share/ant/bin/$wrapper" \
        --set JAVA_HOME "${jre.home}" \
        --set ANT_HOME "$out/share/ant" \
        --prefix CLASSPATH : "$out/share/ant/lib"
    done
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
    maintainers = [ ] ++ lib.teams.java.members;
    platforms = lib.platforms.all;
  };
})
