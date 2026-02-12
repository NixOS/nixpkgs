{
  lib,
  stdenv,
  fetchurl,
  commons-daemon,
  jdk,
  makeWrapper,
  jre,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jsvc";
  version = "1.5.1";

  src = fetchurl {
    url = "mirror://apache/commons/daemon/source/commons-daemon-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-SPnE5jrw1zAy7vIzGrjp0+B4SwCLoufLef3XUcUgK6Y=";
  };

  buildInputs = [ commons-daemon ];
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

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-std=gnu17";

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
})
