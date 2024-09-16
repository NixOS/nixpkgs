{ stdenv
, lib
, fetchurl
, dpkg
, openjdk11
, jnr-posix
, makeWrapper
, openjfx17
, zip
, nixosTests
, bash
}:
stdenv.mkDerivation rec {
  pname = "microsoft-identity-broker";
  version = "2.0.1";

  src = fetchurl {
    url = "https://packages.microsoft.com/ubuntu/22.04/prod/pool/main/m/microsoft-identity-broker/microsoft-identity-broker_${version}_amd64.deb";
    hash = "sha256-O9zbImSWMrRsaOozj5PsCRvQ3UsaJzLfoTohmLZvLkM=";
  };

  nativeBuildInputs = [ dpkg makeWrapper openjdk11 zip ];

  buildPhase = ''
    runHook preBuild

    rm opt/microsoft/identity-broker/lib/jnr-posix-3.1.4.jar
    jar -uf opt/microsoft/identity-broker/lib/javafx-graphics-15-linux.jar -C ${openjfx17}/modules_libs/javafx.graphics/ libglass.so
    jar -uf opt/microsoft/identity-broker/lib/javafx-graphics-15-linux.jar -C ${openjfx17}/modules_libs/javafx.graphics/ libglassgtk3.so
    jar -uf opt/microsoft/identity-broker/lib/javafx-graphics-15-linux.jar -C ${openjfx17}/modules_libs/javafx.graphics/ libprism_es2.so
    zip -d opt/microsoft/identity-broker/lib/javafx-media-15-linux.jar libavplugin-54.so
    zip -d opt/microsoft/identity-broker/lib/javafx-media-15-linux.jar libavplugin-56.so
    zip -d opt/microsoft/identity-broker/lib/javafx-media-15-linux.jar libavplugin-57.so
    zip -d opt/microsoft/identity-broker/lib/javafx-media-15-linux.jar libavplugin-ffmpeg-56.so
    zip -d opt/microsoft/identity-broker/lib/javafx-media-15-linux.jar libavplugin-ffmpeg-57.so
    zip -d opt/microsoft/identity-broker/lib/javafx-media-15-linux.jar libavplugin-ffmpeg-58.so
    jar -uf opt/microsoft/identity-broker/lib/javafx-media-15-linux.jar -C ${openjfx17}/modules_libs/javafx.media/ libavplugin.so
    jar -uf opt/microsoft/identity-broker/lib/javafx-media-15-linux.jar -C ${openjfx17}/modules_libs/javafx.media/ libfxplugins.so
    jar -uf opt/microsoft/identity-broker/lib/javafx-media-15-linux.jar -C ${openjfx17}/modules_libs/javafx.media/ libgstreamer-lite.so
    jar -uf opt/microsoft/identity-broker/lib/javafx-media-15-linux.jar -C ${openjfx17}/modules_libs/javafx.media/ libjfxmedia.so

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
      --add-flags "-classpath $classpath com.microsoft.identity.broker.service.IdentityBrokerService" \
      --add-flags "-verbose"
    makeWrapper ${openjdk11}/bin/java $out/bin/microsoft-identity-device-broker \
      --add-flags "-verbose" \
      --add-flags "-classpath $classpath" \
      --add-flags "com.microsoft.identity.broker.service.DeviceBrokerService" \
      --add-flags "save"

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
        ${openjdk11}/bin/java
  '';

  passthru = {
    updateScript = ./update.sh;
    tests = { inherit (nixosTests) intune; };
  };

  meta = with lib; {
    description = "Microsoft Authentication Broker for Linux";
    homepage = "https://www.microsoft.com/";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ rhysmdnz ];
  };
}
