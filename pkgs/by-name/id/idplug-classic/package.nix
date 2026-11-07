{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  pcsclite,
  openssl,
  glib,
  nssTools,
  curl,
  unzip,
  pango,
  libpng,
  fontconfig,
  gtk3,
  gdk-pixbuf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "idplug-classic";
  version = "4.5.0";

  src = fetchurl {
    url = "https://hub.mai.gov.ro/cei/info/descarca-middleware?versiune=450linux";
    hash = "sha256-TQhEANzYBTX8v14rMZTplgOeyWGZJBVzsdY697/rBIQ=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    pcsclite
    openssl
    glib
    stdenv.cc.cc.lib
    pango
    libpng
    fontconfig
    gtk3
    gdk-pixbuf
  ];

  dontBuild = true;

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x "$src" .
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 usr/lib/idplugclassic/libidplug-pkcs11.so $out/lib/idplugclassic/libidplug-pkcs11.so
    install -Dm755 usr/lib/idplugclassic/libidplug-civapi.so $out/lib/idplugclassic/libidplug-civapi.so
    install -Dm755 usr/lib/idplugclassic/libidplug-pivapi.so $out/lib/idplugclassic/libidplug-pivapi.so

    runHook postInstall
  '';

  postInstall = ''
    install -Dm755 ${./cei-nssdb.in} $out/bin/cei-nssdb
    substituteInPlace $out/bin/cei-nssdb \
      --replace-fail "@shell@"   "${stdenv.shell}" \
      --replace-fail "@libfile@" "$out/lib/idplugclassic/libidplug-pkcs11.so" \
      --replace-fail "@modutil@" "${lib.getExe' nssTools "modutil"}" \
      --replace-fail "@certutil@" "${lib.getExe' nssTools "certutil"}" \
      --replace-fail "@curl@"    "${lib.getExe curl}" \
      --replace-fail "@unzip@"   "${lib.getExe unzip}"
  '';

  meta = {
    description = "Romanian eID PKCS#11 middleware for DGEP ID-A cards (CEI)";
    longDescription = ''
      Provides the PKCS#11 library for Romanian electronic ID cards (CEI, issued by DGEP/MAI).
      Also requires a running pcscd service and compatible card reader.

      To register the PKCS#11 module and trust the MAI CA certificates in NSS-compatible
      browsers (Firefox, Chromium, Okular, etc.), run as a regular user:
        $ cei-nssdb add
        $ cei-nssdb add-certs

      To register system-wide for all users (run as root):
        # cei-nssdb --system add
        # cei-nssdb --system add-certs

      Before uninstalling, remove the registrations:
        $ cei-nssdb remove
        $ cei-nssdb remove-certs
    '';
    homepage = "https://hub.mai.gov.ro/aplicatie-cei";
    platforms = lib.platforms.linux;
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.termozour ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
