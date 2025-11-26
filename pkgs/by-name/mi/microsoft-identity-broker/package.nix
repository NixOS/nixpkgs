{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  nixosTests,
  libuuid,
  xorg,
  curlMinimal,
  openssl_3,
  libsecret,
  webkitgtk_4_1,
  libsoup_3,
  gtk3,
  atk,
  pango,
  glib,
  gdk-pixbuf,
  harfbuzz,
  p11-kit,
  cairo,
  zlib,
  dbus,
}:
let
  curlMinimal_openssl_3 = curlMinimal.override {
    openssl = openssl_3;
  };

  runtimeLibPath = lib.makeLibraryPath [
    stdenv.cc.cc
    libuuid
    xorg.libX11
    curlMinimal_openssl_3
    openssl_3
    libsecret
    webkitgtk_4_1
    libsoup_3
    gtk3
    atk
    glib
    pango
    harfbuzz
    cairo
    p11-kit
    gdk-pixbuf
    zlib
    dbus
  ];
in
stdenv.mkDerivation rec {
  pname = "microsoft-identity-broker";
  version = "2.0.3";

  src = fetchurl {
    url = "https://packages.microsoft.com/ubuntu/24.04/prod/pool/main/m/microsoft-identity-broker/microsoft-identity-broker_${version}_amd64.deb";
    hash = "sha256-vorPf5pvNLABwntiDdfDSiubg1jbHaKK/o0fFkbZ000=";
  };

  nativeBuildInputs = [ dpkg ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) --set-rpath ${runtimeLibPath} usr/bin/microsoft-identity-broker
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) --set-rpath ${runtimeLibPath} usr/bin/microsoft-identity-device-broker

    cp -a usr/* $out

    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace $out/share/dbus-1/services/com.microsoft.identity.broker1.service \
      --replace-fail /usr/bin/microsoft-identity-broker $out/bin/microsoft-identity-broker

    substituteInPlace $out/lib/systemd/system/microsoft-identity-device-broker.service \
      --replace-fail /usr/bin/microsoft-identity-device-broker $out/bin/microsoft-identity-device-broker
  '';

  dontPatchELF = true;

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
