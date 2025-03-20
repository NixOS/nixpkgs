{
  lib,
  stdenv,
  fetchurl,
  commonsDaemon,
  jdk,
  makeWrapper,
  jre,
}:

stdenv.mkDerivation rec {
  pname = "jsvc";
  version = "1.4.1";

  src = fetchurl {
    url = "https://downloads.apache.org//commons/daemon/source/commons-daemon-${version}-src.tar.gz";
    sha256 = "sha256-yPsiNFbqbfDGHzxlr7So8sZt395BABYEJ7jOmLEhUTE=";
  };

  buildInputs = [ commonsDaemon ];
  nativeBuildInputs = [
    jdk
    makeWrapper
  ];

  preConfigure = ''
    cd ./src/native/unix/
    sh ./support/buildconf.sh
  '';

  preBuild = ''
    export JAVA_HOME=${jre}
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp jsvc $out/bin/jsvc
    chmod +x $out/bin/jsvc
    wrapProgram $out/bin/jsvc --set JAVA_HOME "${jre}"
    runHook postInstall
  '';

  meta = {
    homepage = "https://commons.apache.org/proper/commons-daemon";
    description = "Part of the Apache Commons Daemon software, a set of utilities and Java support classes for running Java applications as server processes";
    maintainers = with lib.maintainers; [ rsynnest ];
    license = lib.licenses.asl20;
    platforms = with lib.platforms; unix;
    mainProgram = "jsvc";
  };
}
