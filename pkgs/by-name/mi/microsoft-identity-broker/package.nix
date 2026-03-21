{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  nixosTests,
  dbus,
  util-linux,
  curl,
  openssl,
  libx11,
  webkitgtk_4_1,
  gtk3,
  zlib,
  pango,
  harfbuzz,
  atk,
  cairo,
  gdk-pixbuf,
  libsoup_3,
  glib,
  libsecret,
  p11-kit,
}:
stdenv.mkDerivation rec {
  pname = "microsoft-identity-broker";
  version = "2.5.0";

  src = fetchurl {
    url = "https://packages.microsoft.com/ubuntu/24.04/prod/pool/main/m/microsoft-identity-broker/microsoft-identity-broker_${version}-noble_amd64.deb";
    hash = "sha256-zid9kjjz3mBfJFfiYUoqlIyQSsR041JN3Ib+JFSSEbE=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    dbus
    util-linux
    curl
    openssl
    libx11
    webkitgtk_4_1
    gtk3
    zlib
    pango
    harfbuzz
    atk
    cairo
    gdk-pixbuf
    libsoup_3
    glib
    libsecret
    p11-kit
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -a opt/microsoft/identity-broker/bin/* $out/bin/
    cp -a usr/* $out/

    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace $out/lib/systemd/system/microsoft-identity-device-broker.service \
      --replace-fail \
        /opt/microsoft/identity-broker/bin/microsoft-identity-device-broker \
        $out/bin/microsoft-identity-device-broker

    substituteInPlace $out/share/dbus-1/services/com.microsoft.identity.broker1.service \
      --replace-fail \
        /opt/microsoft/identity-broker/bin/microsoft-identity-broker \
        $out/bin/microsoft-identity-broker
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
