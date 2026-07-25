{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, dpkg
, wrapGAppsHook3
, makeWrapper
, glib
, gtk3
, webkitgtk_4_1
, libsoup_3
, openssl
, zlib
, pango
, cairo
, gdk-pixbuf
, atk
, libappindicator-gtk3
, libx11
, libxcomposite
, libxdamage
, libxext
, libxfixes
, libxrender
, libxrandr
, libxcb
, libxkbcommon
, libdrm
, mesa
, gsettings-desktop-schemas
, fontconfig
, at-spi2-atk
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chronicler";
  version = "0.56.3-alpha";

  src = fetchurl {
    url = "https://github.com/mak-kirkland/chronicler/releases/download/v${finalAttrs.version}/Chronicler_${lib.head (lib.splitString "-" finalAttrs.version)}_amd64.deb";
    hash = "sha256-0MEh1Zp2hmfBZI2WcpNh58AHOnmLexteIVSllmzefnM=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    webkitgtk_4_1
    libsoup_3
    openssl
    zlib
    pango
    cairo
    gdk-pixbuf
    atk
    at-spi2-atk
    libappindicator-gtk3
    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrender
    libxrandr
    libxcb
    libxkbcommon
    libdrm
    mesa
    gsettings-desktop-schemas
    fontconfig
    stdenv.cc.cc.lib
  ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share $out/lib/chronicler
    
    # 1. Copy the internal app files to our private lib directory
    cp -r usr/lib/chronicler/* $out/lib/chronicler/ 2>/dev/null || true
    
    # 2. Copy the actual binary (found in usr/bin) into our private lib
    cp usr/bin/chronicler $out/lib/chronicler/chronicler-bin 2>/dev/null || cp usr/bin/* $out/lib/chronicler/chronicler-bin

    # 3. Create a clean symlink from bin to the real binary
    ln -s $out/lib/chronicler/chronicler-bin $out/bin/chronicler

    # 4. Copy icons and desktop files
    cp -r usr/share/* $out/share/ 2>/dev/null || true

    # 5. Fix .desktop file path
    if [ -f "$out/share/applications/chronicler.desktop" ]; then
      substituteInPlace "$out/share/applications/chronicler.desktop" \
        --replace-fail "Exec=chronicler" "Exec=$out/bin/chronicler"
    fi

    runHook postInstall
  '';

  appendRunpaths = [ "${stdenv.cc.cc.lib}/lib" ];

  meta = {
    description = "A free, offline worldbuilding tool and local wiki for writers and RPG creators";
    homepage = "https://chronicler.pro/";
    license = lib.licenses.polyFormShield100;
    maintainers = with lib.maintainers; [ enderfare frozenoverthemoon ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "chronicler";
  };
})
