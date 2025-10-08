{
  cacert,
  dpkg,
  fetchurl,
  gdk-pixbuf,
  glib,
  glibc,
  gtk3,
  icu,
  lib,
  libcap,
  librsvg,
  libusb1,
  makeWrapper,
  openssl,
  patchelf,
  stdenv,
  systemdMinimal,
  onetbb,
  writeTextDir,
}:

let
  sources =
    (lib.importJSON ./sources.json).${stdenv.system} or (throw "unsupported system ${stdenv.system}");

  libraryPath = lib.makeLibraryPath libraries;
  libraries = [
    gdk-pixbuf
    glibc
    gtk3
    icu
    libcap
    librsvg
    libusb1
    openssl
    stdenv.cc.cc.lib
    systemdMinimal
    onetbb
  ];

  gdkLoadersCache = "${gdk-pixbuf.out}/${gdk-pixbuf.moduleDir}.cache";

in
stdenv.mkDerivation {
  pname = "picoscope";
  inherit (sources.picoscope) version;

  srcs = lib.mapAttrsToList (_: src: fetchurl { inherit (src) url sha256; }) sources;

  unpackPhase = ''
    for src in $srcs; do
      dpkg-deb -x "$src" .
    done
  '';

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  buildInputs = libraries;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/
    cp -dr opt/picoscope/* $out/
    chmod +x $out/lib/PicoScope.GTK

    # Patch all ELF files to prefer Pico libs then our curated runtime
    # Set dynamic loader to Nix's glibc ld.so
    for f in $out/lib/{PicoScope.GTK,CrashReporter} $(find $out/lib -type f -name 'lib*.so*'); do
      ${patchelf}/bin/patchelf \
        --set-interpreter ${glibc.out}/lib/ld-linux-x86-64.so.2 \
        --set-rpath "$out/lib:${libraryPath}" \
        "$f" || true
    done

    # LD_LIBRARY_PATH: not strictly needed for the main exe (rpath already covers it), but required
    # for dlopened plugins that ignore rpath or use absolute sonames.
    # GDK_PIXBUF_MODULE_FILE: points gdk-pixbuf to Nix’s loader cache so image loaders (gif/svg/png)
    # come from our matched version, not the host. This fixes the “g_module_*” symbol errors.
    # GIO_MODULE_DIR: restricts GIO to GLib’s core modules only (no dconf/gvfs host bleed-through).
    # SSL_CERT_DIR/SSL_CERT_FILE: Gives OpenSSL a known CA bundle so any HTTPS inside the app works
    # without querying host paths.
    makeWrapper $out/lib/PicoScope.GTK $out/bin/picoscope \
      --set LD_LIBRARY_PATH "$out/lib:${libraryPath}" \
      --set GDK_PIXBUF_MODULE_FILE "${gdkLoadersCache}" \
      --set GIO_MODULE_DIR "${glib.out}/lib/gio/modules" \
      --set SSL_CERT_DIR "${cacert}/etc/ssl/certs" \
      --set SSL_CERT_FILE "${cacert}/etc/ssl/certs/ca-bundle.crt"
    runHook postInstall
  '';

  # Stripping causes the following error:
  #   Failure processing application bundle; possible file corruption.
  #   Arithmetic overflow while reading bundle.
  #   A fatal error occurred while processing application bundle
  dontStrip = true;

  # usage:
  # services.udev.packages = [ pkgs.picoscope.rules ];
  # users.groups.pico = {};
  # users.users.you.extraGroups = [ "pico" ];
  passthru.rules = writeTextDir "lib/udev/rules.d/95-pico.rules" ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0ce9", MODE="664",GROUP="pico"
  '';

  meta = {
    homepage = "https://www.picotech.com/downloads/linux";
    maintainers = with lib.maintainers; [ wirew0rm ] ++ lib.teams.lumiguide.members;
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    description = "Oscilloscope application that works with all PicoScope models";
    longDescription = ''
      PicoScope for Linux is a powerful oscilloscope application that works
      with all PicoScope models. The most important features from PicoScope
      for Windows are included—scope, spectrum analyzer, advanced triggers,
      automated measurements, interactive zoom, persistence modes and signal
      generator control. More features are being added all the time.

      Waveform captures can be saved for off-line analysis, and shared with
      PicoScope for Linux, PicoScope for macOS and PicoScope for Windows
      users, or exported in text, CSV and MathWorks MATLAB 4 formats.
    '';
  };
}
