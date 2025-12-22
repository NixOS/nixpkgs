{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre_headless,
  nixosTests,
}:
stdenv.mkDerivation rec {
  pname = "jelu";
  version = "0.75.2";

  src = fetchurl {
    url = "https://github.com/bayang/jelu/releases/download/v${version}/jelu-${version}.jar";
    hash = "sha256-dTd5dx8PWWfz/PGYheGabr3Lu7WxG/XDVW/huPHz7KY=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  # TODO: Build from source using buildGradleApplication once Gradle build support
  # is more mature. Currently using pre-built JAR due to complex build process
  # combining Java (Gradle) and Node.js (for the web UI).
  installPhase = ''
    runHook preInstall

    install -Dm444 $src $out/share/jelu/jelu.jar

    makeWrapper ${jre_headless}/bin/java $out/bin/jelu \
      --add-flags "-jar $out/share/jelu/jelu.jar" \
      --set JAVA_HOME ${jre_headless}

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) jelu;
  };

  meta = with lib; {
    description = "Self hosted read and to-read list book tracker";
    longDescription = ''
      Jelu is a self-hosted book tracking application that allows you to track
      what you have read, what you are reading, and what you want to read.
      It provides an alternative to online services like Goodreads, giving you
      full control over your reading data.
    '';
    homepage = "https://github.com/bayang/jelu";
    changelog = "https://github.com/bayang/jelu/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ m0streng0 ];
    platforms = platforms.all;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    mainProgram = "jelu";
  };
}
