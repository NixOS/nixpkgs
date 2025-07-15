{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "kiro";
  version = "202507140012";

  src = pkgs.fetchurl {
    url = "https://prod.download.desktop.kiro.dev/releases/202507140012--distro-linux-x64-tar-gz/202507140012-distro-linux-x64.tar.gz";
    sha256 = "0za8zpfffhww8qrd7z7qd63n5sg8df7n4wl6ab3xz26xg7ydrdp9";
  };

  nativeBuildInputs = [
    pkgs.autoPatchelfHook
    pkgs.makeWrapper
  ];

  buildInputs = with pkgs; [
    glib
    nss
    nspr
    dbus
    atk
    at-spi2-atk
    cups
    libdrm
    gtk3
    pango
    cairo
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    mesa
    expat
    xorg.libxcb
    libxkbcommon
    xorg.libxkbfile
    alsa-lib
    at-spi2-core
    libglvnd
    electron
  ];

  dontStrip = true;

  installPhase = ''
    mkdir -p $out/lib/kiro
    cp -r ./* $out/lib/kiro/

    # Patch ELF files before removing bundled Electron components
    find $out/lib/kiro -type f -exec patchelf --set-rpath "${pkgs.lib.makeLibraryPath buildInputs}" {} \; || true

    # Remove bundled Electron components
    rm $out/lib/kiro/kiro
    rm $out/lib/kiro/chrome_crashpad_handler
    rm $out/lib/kiro/chrome-sandbox
    rm $out/lib/kiro/libEGL.so
    rm $out/lib/kiro/libGLESv2.so
    rm $out/lib/kiro/libvk_swiftshader.so
    rm $out/lib/kiro/libvulkan.so.1
    rm $out/lib/kiro/libffmpeg.so

    # Ensure resources are in the correct place for system electron
    mv $out/lib/kiro/resources $out/lib/kiro/electron-resources

    # Create wrapper for system electron
    makeWrapper ${pkgs.electron}/bin/electron $out/bin/kiro \
      --add-flags "$out/lib/kiro/electron-resources/app --no-sandbox --disable-gpu-sandbox"
  '';

  meta = with pkgs.lib; {
    description = "Kiro is an development environment that uses AI agents";
    homepage = "https://kiro.dev/";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ deftdawg ];
  };
}
