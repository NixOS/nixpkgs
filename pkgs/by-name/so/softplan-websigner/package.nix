{
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  lib,
  # Build-time dependencies (for autoPatchelfHook)
  glibc,
  gcc-unwrapped,
  zlib,
  # Runtime dependencies for GUI and features
  xorg,
  gtk3,
  glib,
  cairo,
  pango,
  gdk-pixbuf,
  fontconfig,
  freetype,
  mesa,
  opensc,
  pcsclite,
  nss,
  p11-kit,
  ccid,
}:

stdenv.mkDerivation rec {
  pname = "softplan-websigner";
  version = "2.12.1";

  src = fetchurl {
    url = "https://websigner.softplan.com.br/Downloads/${version}/setup-deb-64";
    sha256 = "sha256-Xaj9NvE3H1K7rr7edfreGSjwnP8t1gW42lZjxtpQU3k=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    glibc
    gcc-unwrapped.lib
    zlib
  ];

  runtimeLibraries = [
    # Essential X11 libraries for Avalonia GUI
    xorg.libX11
    xorg.libxcb
    xorg.libXext
    xorg.libXrender
    xorg.libXrandr
    xorg.libXi
    xorg.libXfixes
    xorg.libXdamage
    xorg.libXcursor
    # Essential graphics/GTK stack for SkiaSharp/.NET
    gtk3
    glib
    cairo
    pango
    gdk-pixbuf
    fontconfig
    freetype
    mesa
    # Smart card libraries (optional runtime features)
    opensc
    pcsclite
    nss
    p11-kit
    ccid
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb --fsys-tarfile $src | tar -x --no-same-owner
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    # Create output directories
    mkdir -p $out/opt/softplan-websigner
    mkdir -p $out/bin

    # Native messaging hosts
    mkdir -p $out/lib/mozilla/native-messaging-hosts
    mkdir -p $out/share/mozilla/native-messaging-hosts
    mkdir -p $out/etc/chromium/native-messaging-hosts
    mkdir -p $out/etc/chrome/native-messaging-hosts
    mkdir -p $out/etc/opt/chrome/native-messaging-hosts

    # Copy application
    cp -r opt/softplan-websigner/* $out/opt/softplan-websigner/

    # Copy native messaging configs
    if [ -d usr/lib/mozilla/native-messaging-hosts ]; then
      cp -r usr/lib/mozilla/native-messaging-hosts/* $out/lib/mozilla/native-messaging-hosts/
    fi
    if [ -d usr/lib64/mozilla/native-messaging-hosts ]; then
      cp -r usr/lib64/mozilla/native-messaging-hosts/* $out/lib/mozilla/native-messaging-hosts/
    fi
    if [ -d usr/share/mozilla/native-messaging-hosts ]; then
      cp -r usr/share/mozilla/native-messaging-hosts/* $out/share/mozilla/native-messaging-hosts/
    fi

    # Chrome native messaging
    if [ -f opt/softplan-websigner/manifest.json ]; then
      cp opt/softplan-websigner/manifest.json $out/etc/chromium/native-messaging-hosts/br.com.softplan.webpki.json
      cp opt/softplan-websigner/manifest.json $out/etc/chrome/native-messaging-hosts/br.com.softplan.webpki.json
      cp opt/softplan-websigner/manifest.json $out/etc/opt/chrome/native-messaging-hosts/br.com.softplan.webpki.json
    fi

    # RUNTIME wrapper - only runtime libraries in LD_LIBRARY_PATH
    makeWrapper $out/opt/softplan-websigner/websigner $out/bin/websigner \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibraries}" \
      --set DOTNET_SYSTEM_GLOBALIZATION_INVARIANT false \
      --set PCSCLITE_LIBRARY "${pcsclite}/lib/libpcsclite.so.1" \
      --set OPENSC_LIBS "${opensc}/lib" \
      --prefix PKG_CONFIG_PATH : "${opensc}/lib/pkgconfig:${pcsclite}/lib/pkgconfig:${p11-kit}/lib/pkgconfig"

    chmod +x $out/opt/softplan-websigner/websigner

    runHook postInstall
  '';

  postInstall = ''
    # Update native messaging host configs
    for dir in lib/mozilla/native-messaging-hosts share/mozilla/native-messaging-hosts etc/chromium/native-messaging-hosts etc/chrome/native-messaging-hosts etc/opt/chrome/native-messaging-hosts; do
      for file in $out/$dir/*.json; do
        if [ -f "$file" ]; then
          sed -i "s|/opt/softplan-websigner/websigner|$out/bin/websigner|g" "$file"
        fi
      done
    done
  '';

  passthru = {
    nativeMessagingHosts = {
      firefox = "$out/lib/mozilla/native-messaging-hosts";
      chrome = "$out/etc/chromium/native-messaging-hosts";
      chromium = "$out/etc/chromium/native-messaging-hosts";
    };
  };

  meta = with lib; {
    description = "Digital signature application with smart card support";
    homepage = "https://websigner.softplan.com.br/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ daviaaze ];
    mainProgram = "websigner";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
