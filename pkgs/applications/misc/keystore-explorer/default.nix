{ fetchzip, lib, stdenv, jdk, runtimeShell, glib, wrapGAppsHook }:

stdenv.mkDerivation rec {
  version = "5.5.2";
  pname = "keystore-explorer";
  src = fetchzip {
    url = "https://github.com/kaikramer/keystore-explorer/releases/download/v${version}/kse-${lib.replaceStrings ["."] [""] version}.zip";
    sha256 = "sha256-mDi/TSYumCg2hAnMOI2QpdAOSlDMpdJPqzatFotAqUk=";
  };

  # glib is necessary so file dialogs don't hang.
  buildInputs = [ glib ];
  nativeBuildInputs = [ wrapGAppsHook ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/keystore-explorer
    cp -R icons licenses lib kse.jar $out/share/keystore-explorer/

    # keystore-explorer's kse.sh tries to detect the path of Java by using
    # Python on Darwin; just write our own start script to avoid unnecessary dependencies
    cat > $out/bin/keystore-explorer <<EOF
    #!${runtimeShell}
    export JAVA_HOME=${jdk.home}
    exec ${jdk}/bin/java -jar $out/share/keystore-explorer/kse.jar "\$@"
    EOF
    chmod +x $out/bin/keystore-explorer

    runHook postInstall
  '';

  dontStrip = true;
  dontBuild = true;
  dontConfigure = true;

  meta = {
    description = "Open source GUI replacement for the Java command-line utilities keytool and jarsigner";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.numinit ];
    platforms = lib.platforms.unix;
  };
}
