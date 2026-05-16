{
  lib,
  stdenv,
  fetchurl,
  jdk,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ant-bootstrap";
  version = "1.10.15";

  src = fetchurl {
    url = "mirror://apache/ant/source/apache-ant-${finalAttrs.version}-src.tar.bz2";
    hash = "sha256-WPU+khKoAFW/FOknicf1BCBqs1uLw5dfo7cocg2A79c=";
  };

  nativeBuildInputs = [
    jdk
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild
    sh bootstrap.sh
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/ant
    cp -r bootstrap/* $out/share/ant/
    rm -rf $out/share/ant/bin/*.bat

    makeWrapper $out/share/ant/bin/ant $out/bin/ant \
      --set ANT_HOME $out/share/ant \
      --set JAVA_HOME ${jdk.home}
    runHook postInstall
  '';

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    homepage = "https://ant.apache.org/";
    description = "Java-based build tool (bootstrapped from source)";
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    license = lib.licenses.asl20;
    teams = [ lib.teams.java ];
    platforms = lib.platforms.all;
    mainProgram = "ant";
  };
})
