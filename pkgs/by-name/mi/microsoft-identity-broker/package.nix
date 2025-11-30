{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  openjdk11,
  jnr-posix,
  makeWrapper,
  zip,
  nixosTests,
  bash,
  glib,
  xorg,
  alsa-lib,
}:
stdenv.mkDerivation rec {
  pname = "microsoft-identity-broker";
  version = "2.0.1";

  src = fetchurl {
    url = "https://packages.microsoft.com/ubuntu/24.04/prod/pool/main/m/microsoft-identity-broker/microsoft-identity-broker_${version}_amd64.deb";
    hash = "sha256-JheJnsu1ZxJbcpt0367FqfHVdwWWvPem2fm0i8s7MGE=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    openjdk11
    zip
  ];

  buildInputs = [
    glib
    xorg.libXtst
    alsa-lib
  ];

  buildPhase = ''
    runHook preBuild
    rm opt/microsoft/identity-broker/lib/jnr-posix-3.1.4.jar
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/microsoft-identity-broker
    cp -a opt/microsoft/identity-broker/lib/* $out/lib/microsoft-identity-broker
    cp -a usr/* $out
    for jar in $out/lib/microsoft-identity-broker/*.jar; do
      classpath="$classpath:$jar"
    done
    classpath="$classpath:${jnr-posix}/share/java/jnr-posix-${jnr-posix.version}.jar"
    mkdir -p $out/bin
    makeWrapper ${openjdk11}/bin/java $out/bin/microsoft-identity-broker \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}" \
      --add-flags "-classpath $classpath" \
      --add-flags "-Xmx256m -Xss256k -XX:+UseParallelGC -XX:ParallelGCThreads=1" \
      --add-flags "-verbose" \
      --add-flags "-Djava.net.useSystemProxies=true" \
      --add-flags "com.microsoft.identity.broker.service.IdentityBrokerService"

    makeWrapper ${openjdk11}/bin/java $out/bin/microsoft-identity-device-broker \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}" \
      --add-flags "-classpath $classpath" \
      --add-flags "-Xmx256m -Xss256k -XX:+UseParallelGC -XX:ParallelGCThreads=1" \
      --add-flags "-verbose" \
      --add-flags "-Djava.net.useSystemProxies=true" \
      --add-flags "com.microsoft.identity.broker.service.DeviceBrokerService"

    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace \
      $out/lib/systemd/user/microsoft-identity-broker.service \
      $out/lib/systemd/system/microsoft-identity-device-broker.service \
      $out/share/dbus-1/system-services/com.microsoft.identity.devicebroker1.service \
      $out/share/dbus-1/services/com.microsoft.identity.broker1.service \
      --replace \
        ExecStartPre=sh \
        ExecStartPre=${bash}/bin/sh \
      --replace \
        ExecStartPre=!sh \
        ExecStartPre=!${bash}/bin/sh \
      --replace \
        /opt/microsoft/identity-broker/bin/microsoft-identity-broker \
        $out/bin/microsoft-identity-broker \
      --replace \
        /opt/microsoft/identity-broker/bin/microsoft-identity-device-broker \
        $out/bin/microsoft-identity-device-broker \
      --replace \
        /usr/lib/jvm/java-11-openjdk-amd64 \
        ${openjdk11}
  '';

  passthru = {
    updateScript = ./update.sh;
    tests = { inherit (nixosTests) intune; };
  };

  meta = {
    description = "Microsoft Authentication Broker for Linux";
    homepage = "https://www.microsoft.com/";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ rhysmdnz ];
  };
}
