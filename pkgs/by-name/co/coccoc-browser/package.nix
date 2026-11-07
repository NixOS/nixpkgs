{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  makeWrapper,
  cairo,
  pango,
  systemd,
  at-spi2-core,
  qt6,
  glib,
  libxext,
  libxcomposite,
  libxdamage,
  libxfixes,
  libxrandr,
  libx11,
  libxcb,
  nspr,
  nss,
  alsa-lib,
  pipewire,
  vulkan-loader,
  libGL,
  wayland,
  waylandSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "coccoc-browser";
  version = "153.0.150";

  src = fetchurl {
    url = "https://browser-linux.coccoc.com/deb/pool/main/coccoc-browser-stable_147.0.7727.150-1_amd64.deb";
    hash = "sha256-MwQRQiEHdMyTY5E3LxhA7a+/T/eAEGBoCf8NhiFxkYE=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    cairo
    pango
    systemd
    at-spi2-core
    stdenv.cc.cc.lib
    qt6.qtbase
    glib
    libxext
    libxcomposite
    libxdamage
    libxfixes
    libxrandr
    libx11
    libxcb
    nspr
    nss
    alsa-lib
  ];

  dontWrapQtApps = true;

  unpackPhase = ''
    dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/opt $out/share

    cp -R opt/coccoc $out/opt/
    cp -R usr/share/* $out/share/

    # delete qt5 shim to prevent dependency collision
    rm -f $out/opt/coccoc/browser/libqt5_shim.so

    substituteInPlace $out/share/applications/coccoc-browser.desktop \
      --replace-fail "/usr/bin/coccoc-browser-stable" "coccoc-browser"

    for size in 16 24 32 48 64 128 256; do
      if [ -f "$out/opt/coccoc/browser/product_logo_$size.png" ]; then
        mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps
        ln -s "$out/opt/coccoc/browser/product_logo_$size.png" $out/share/icons/hicolor/''${size}x''${size}/apps/coccoc.png
      fi
    done

    ln -s $out/opt/coccoc/browser/coccoc-browser $out/bin/coccoc-browser

    wrapProgram $out/bin/coccoc-browser \
      ${lib.optionalString waylandSupport ''--add-flags "--ozone-platform-hint=auto" --add-flags "--enable-features=WaylandWindowDecorations"''} \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath (
          [
            pipewire
            vulkan-loader
            libGL
          ]
          ++ lib.optionals waylandSupport [ wayland ]
        )
      }

    runHook postInstall
  '';

  meta = {
    description = "Cốc Cốc! The optimized web browser for vietnamese people";
    homepage = "https://coccoc.com/";
    maintainers = with lib.maintainers; [ aanhlongg ];
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    mainProgram = "coccoc-browser";
  };
})
