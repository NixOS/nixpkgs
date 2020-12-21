{ fetchzip, stdenv, jdk8, runtimeShell }:

stdenv.mkDerivation rec {
  version = "5.4.4";
  pname = "keystore-explorer";
  src = fetchzip {
    url = "https://github.com/kaikramer/keystore-explorer/releases/download/v${version}/kse-544.zip";
    sha256 = "01kpa8g6p6vcqq9y70w5bm8jbw4kp55pbywj2zrhgjibrhgjqi0b";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/keystore-explorer
    cp -R icons licenses lib kse.jar $out/share/keystore-explorer/

    # keystore-explorer's kse.sh tries to detect the path of Java by using
    # Python on Darwin; just write our own start script to avoid unnecessary dependencies
    cat > $out/bin/keystore-explorer <<EOF
    #!${runtimeShell}
    export JAVA_HOME=${jdk8.home}
    exec ${jdk8}/bin/java -jar $out/share/keystore-explorer/kse.jar "\$@"
    EOF
    chmod +x $out/bin/keystore-explorer

    runHook postInstall
  '';

  dontStrip = true;
  dontBuild = true;
  dontConfigure = true;

  meta = {
    description = "Open source GUI replacement for the Java command-line utilities keytool and jarsigner";
    license = stdenv.lib.licenses.gpl3Only;
    maintainers = [ stdenv.lib.maintainers.numinit ];
    platforms = stdenv.lib.platforms.unix;
  };
}
