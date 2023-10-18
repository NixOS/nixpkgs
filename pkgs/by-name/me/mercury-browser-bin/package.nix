{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, dpkg
, wrapGAppsHook
, alsa-lib
, browserpass
, bukubrow
, cairo
, cups
, dbus
, dbus-glib
, ffmpeg
, fontconfig
, freetype
, fx-cast-bridge
, glib
, glibc
, gnome-browser-connector
, gtk3
, harfbuzz
, libcanberra
, libdbusmenu
, libdbusmenu-gtk3
, libglvnd
, libjack2
, libkrb5
, libnotify
, libpulseaudio
, libva
, lyx
, mesa
, nspr
, nss
, opensc
, pango
, pciutils
, pipewire
, plasma5Packages
, sndio
, speechd
, tridactyl-native
, udev
, uget-integrator
, vulkan-loader
, xdg-utils
, xorg
, simd ? "SSE3"
}:

stdenv.mkDerivation rec {
  pname = "mercury-browser-bin";
  version = "122.0.2";

  src = fetchurl {
    url =
    "https://github.com/Alex313031/Mercury/releases/download/v.${version}/mercury-browser_${version}_${simd}.deb";
    hash = {
      AVX2_hash = "sha256-mF2MvfbNUksJECHIMis8GlgiEzGiLe7NImRSnMSR37o=";
      AVX_hash = "sha256-MbFZlDv2wruNfVcw5GcKl1KLqsstcUbFo/ELfuNK3dg=";
      SSE4_hash = "sha256-vNRS37uLYIN7WVwaS0sX058oXOWPfwjmIv1VOaJ1v5g=";
      SSE3_hash = "sha256-txDISoNW9/pXarn/8QfQhSo8AHFqPbrxjXwyUo3f3MA=";
    }."${simd}_hash";
  };

  nativeBuildInputs = [ autoPatchelfHook dpkg wrapGAppsHook ];

  buildInputs = [
    stdenv.cc.cc.lib
    alsa-lib
    browserpass
    bukubrow
    cairo
    cups
    dbus
    dbus-glib
    ffmpeg
    fontconfig
    freetype
    fx-cast-bridge
    glib
    glibc
    gnome-browser-connector
    gtk3
    harfbuzz
    libcanberra
    libdbusmenu
    libdbusmenu-gtk3
    libglvnd
    libjack2
    libkrb5
    libnotify
    libpulseaudio
    libva
    lyx
    mesa
    nspr
    nss
    opensc
    pango
    pciutils
    pipewire
    plasma5Packages.plasma-browser-integration
    sndio
    speechd
    tridactyl-native
    udev
    uget-integrator
    vulkan-loader
    xdg-utils
    xorg.libxcb
    xorg.libX11
    xorg.libXcursor
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libXxf86vm
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r usr/* $out

    substituteInPlace $out/share/applications/mercury-browser.desktop \
      --replace Exec=mercury-browser Exec=$out/bin/mercury-browser \
      --replace StartupWMClass=mercury StartupWMClass=mercury-default \
      --replace Icon=mercury Icon=$out/share/icons/hicolor/512x512/apps/mercury.png
    addAutoPatchelfSearchPath $out/lib/mercury
    substituteInPlace $out/bin/mercury-browser \
      --replace 'export LD_LIBRARY_PATH' "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:${
        lib.makeLibraryPath buildInputs
      }:$out/lib/mercury" \
      --replace /usr $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "Compiler-optimized private Firefox fork";
    homepage = "https://thorium.rocks/mercury";
    maintainers = with lib.maintainers; [ redxtech ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mpl20;
    platforms = [ "x86_64-linux" ];
    mainProgram = "mercury-browser";
  };
}
