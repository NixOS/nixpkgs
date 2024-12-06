{
  lib,
  stdenv,
  fetchzip,
  jdk,
  nixosTests,
}:
stdenv.mkDerivation rec {
  pname = "nifi";
  version = "2.0.0";

  src = fetchzip {
    url = "mirror://apache/nifi/${version}/nifi-${version}-bin.zip";
    hash = "sha256-uEMDmF758wBk/RlPCJV5Hd1G1lORc094R/rXnaI79HA=";
  };

  buildInputs = [ jdk ];

  installPhase = ''
    runHook preInstall

    cp -r . $out
    mkdir -p $out/share/doc/nifi $out/share/nifi
    mv $out/{LICENSE,NOTICE,README} $out/share/doc/nifi
    substituteInPlace $out/bin/nifi.sh \
      --replace-fail "/bin/sh" "${stdenv.shell}"
    substituteInPlace $out/bin/nifi-env.sh \
      --replace-fail "#export JAVA_HOME=/usr/java/jdk/" "export JAVA_HOME=${jdk}/" \
      --replace-fail "export NIFI_PID_DIR" "export NIFI_PID_DIR=\$HOME/.nifi/run" \
      --replace-fail "export NIFI_LOG_DIR" "export NIFI_LOG_DIR=\$HOME/.nifi/logs"
    ln -s $out/conf $out/share/nifi/conf

    runHook postInstall
  '';

  passthru.tests.nifi = nixosTests.nifi;

  meta = {
    description = "Easy to use, powerful, and reliable system to process and distribute data";
    longDescription = ''
      Apache NiFi supports powerful and scalable directed graphs of data routing,
      transformation, and system mediation logic.
    '';
    license = lib.licenses.asl20;
    homepage = "https://nifi.apache.org";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [ izorkin ];
  };
}
