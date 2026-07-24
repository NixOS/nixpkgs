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
, libX11
, libXcomposite
, libXdamage
, libXext
, libXfixes
, libXrender
, libXrandr
, libxcb
, libxkbcommon
, libdrm
, mesa
, gsettings-desktop-schemas
, fontconfig
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
    libappindicator-gtk3
    libX11
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXrender
    libXrandr
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

    mkdir -p $out/bin $out/share $out/lib
    
    # Copy binaries, icons/desktop files, and internal libraries
    cp -r usr/bin/*       $out/bin/
    cp -r usr/share/*     $out/share/ 2>/dev/null || true
    cp -r usr/lib/*       $out/lib/   2>/dev/null || true

    # Fix .desktop file: set Exec to the Nix store path (Ender's good idea)
    for f in $out/share/applications/*.desktop; do
      if [ -f "$f" ]; then
        substituteInPlace "$f" --replace-fail "Exec=chronicler" "Exec=$out/bin/chronicler"
      fi
    done

    runHook postInstall
  '';

  # Ensures the app finds its own internal libraries and C++ libs
  appendRunpaths = [ 
    "${stdenv.cc.cc.lib}/lib"
    "$out/lib/chronicler"
  ];

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
