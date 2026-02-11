{
  lib,
  stdenvNoCC,
  fetchzip,
  jdk,
  gawk,
  makeBinaryWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kafka-cmak";
  version = "3.0.0.6";

  src = fetchzip {
    url = "https://github.com/yahoo/CMAK/releases/latest/download/cmak-${finalAttrs.version}.zip";
    hash = "sha256-jMF1v2WV8ataFkz2VuVXOE6/QV+Kb0KBVRfj8yKdkUQ=";
  };

  buildInputs = [
    gawk
    jdk
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv ./* $out
    wrapProgram $out/bin/cmak \
      --set JAVA_HOME ${jdk.home} \
      --prefix PATH : ${lib.makeBinPath [ gawk ]}

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Cluster Manager for Apache Kafka, previously known as Kafka Manager";
    license = lib.licenses.apsl20;
    maintainers = with lib.maintainers; [ cafkafk ];
    platforms = lib.platforms.unix;
    mainProgram = "cmak";
  };
})
