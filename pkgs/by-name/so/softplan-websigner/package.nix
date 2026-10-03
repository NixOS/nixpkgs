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
  # Runtime dependencies needed by the .NET/Avalonia binary
  libx11,
  libxext,
  libxi,
  libxrandr,
  libxcursor,
  libice,
  libsm,
  gtk3,
  glib,
  fontconfig,
  libglvnd,
  openssl,
  icu,
  libkrb5,
  # Smart card support (invoked at runtime, not via dlopen at startup)
  opensc,
  pcsclite,
  nss,
  p11-kit,
}:

stdenv.mkDerivation rec {
  pname = "softplan-websigner";
  version = "2.12.1";

  src = fetchurl {
    url = "https://websigner.softplan.com.br/Downloads/${version}/setup-deb-64";
    hash = "sha256-BPpB6WLZHk1zN/RwdHlDe/Zg8ZBX+sY4KftGeE7ggok=";
  };

  strictDeps = true;
  __structuredAttrs = true;

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

  # Libraries that the .NET/Avalonia single-file binary dlopen()s at runtime.
  # These are placed in LD_LIBRARY_PATH so the dynamic linker can find them.
  # Libraries not listed here (libxcb, libXrender, libXdamage, libXfixes,
  # cairo, pango, gdk-pixbuf, freetype, ccid) are either not referenced
  # by the binary or are pulled in transitively via gtk3's RPATH.
  runtimeLibraries = [
    # X11 and session management — required by Avalonia
    libx11
    libxext
    libxi
    libxrandr
    libxcursor
    libice
    libsm
    # GTK3 stack — used by Avalonia for file dialogs and clipboard
    gtk3
    glib
    fontconfig
    # OpenGL — used by SkiaSharp for GPU rendering
    libglvnd
    # .NET runtime dependencies
    openssl
    icu
    libkrb5
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

    # RUNTIME wrapper — only runtime libraries in LD_LIBRARY_PATH
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

  meta = {
    description = "Digital signature application with smart card support";
    homepage = "https://websigner.softplan.com.br/";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ daviaaze ];
    mainProgram = "websigner";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
