{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook4,
  dbus,
  zlib,
  fontconfig,
  openssl,
  libappindicator,
  webkitgtk_4_1,
  gtk3,
  pango,
  cairo,
  gdk-pixbuf,
  libsoup_3,
  glib,
  glib-networking,
  gcc,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "atuin-desktop";
  version = "0.1.3";

  src = fetchurl {
    url = "https://github.com/atuinsh/desktop/releases/download/v${finalAttrs.version}/Atuin_Desktop_${finalAttrs.version}_amd64.deb";
    hash = "sha256-bTDaXuIF0m66oGLl3RyPNXAsGU84ryG7Uf4HCGwDfg8=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook4
    pkg-config
  ];

  buildInputs = [
    # System libraries
    dbus
    zlib
    fontconfig

    # GTK and related libraries
    webkitgtk_4_1
    libappindicator
    gtk3
    pango
    cairo
    gdk-pixbuf

    # Network and utility libraries
    libsoup_3

    # GLib libraries
    glib
    glib-networking

    # Runtime dependencies
    gcc.cc.lib # For libgcc_s.so.1
    openssl
  ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r usr/* $out/ || true

    # Ensure desktop files exist and are properly configured
    if [ -d $out/share/applications ]; then
    for desktop in $out/share/applications/*.desktop; do
        if [ -f "$desktop" ]; then
        substituteInPlace "$desktop" \
            --replace "Exec=/usr/bin/" "Exec=$out/bin/"
        fi
    done
    fi
    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # Ensure the binary can find all required libraries
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs}
    )
  '';

  postFixup = ''
    echo "=== Debugging binary ==="
    if [ -f "$out/bin/atuin-desktop" ]; then
      echo "Binary exists"
      file "$out/bin/atuin-desktop"
      ldd "$out/bin/atuin-desktop" || echo "ldd failed"
      readelf -l "$out/bin/atuin-desktop" | grep interpreter || echo "No interpreter found"
    else
      echo "Binary not found, listing contents:"
      find "$out" -name "*atuin*" -type f
    fi
    echo "=== End debugging ==="
    find $out/bin -type f -executable | while read -r bin; do
      echo "Patching binary: $bin"

      # Check if it's an ELF binary
      if file "$bin" | grep -q "ELF"; then
        echo "  Setting interpreter..."
        patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} "$bin" || echo "  Failed to set interpreter"

        echo "  Setting rpath..."
        patchelf --set-rpath ${lib.makeLibraryPath finalAttrs.buildInputs} "$bin" || echo "  Failed to set rpath"

        echo "  Shrinking rpath..."
        patchelf --shrink-rpath "$bin" || echo "  Failed to shrink rpath"
      fi
    done
  '';

  meta = {
    description = "Atuin Desktop";
    homepage = "https://atuin.sh/#desktop-section";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      randoneering
      dzervas
    ];
    platforms = [ "x86_64-linux" ];
  };
})
