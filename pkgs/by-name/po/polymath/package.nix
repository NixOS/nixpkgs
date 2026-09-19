{
  lib,
  stdenv,
  fetchurl,

  dpkg,
  autoPatchelfHook,
  makeWrapper,

  atk,
  coreutils,
  glib,
  gnugrep,
  xprop,
  libayatana-appindicator,
  libsecret,
  libusb1,
  libkrb5,
  runtimeShell,
  curl,
  dbus,
  librsvg,
  libbsd,
  libxv,
  libxml2_13,
  libva,
  gnutls,
  libvdpau,
  alsa-lib,
  pulseaudio,
  mesa,
  libxscrnsaver,
  libxpresent,
}:
stdenv.mkDerivation (finalAttrs: {
  strictDeps = true;
  __structuredAttrs = true;

  pname = "polymath";
  version = "1.4.5.8";

  src = fetchurl {
    url = "https://fluxkeyboard.com/updates/polymath/linux/deb/polymath_${finalAttrs.version}_amd64.deb";
    hash = "sha256-gp4wxzNUIl5pnY8LcJp2Tl3ZXoQk7PfVXk1Ctu3G2wg=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
  ];
  buildInputs = [
    atk
    glib
    libayatana-appindicator
    libsecret
    libusb1
    libkrb5
    librsvg
    libbsd
    libxv
    libxml2_13
    libva
    gnutls
    libvdpau
    alsa-lib
    pulseaudio
    mesa
    libxscrnsaver
    libxpresent
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir $out
    mv usr/* $out/
    rmdir usr
    mv ./* $out/

    for script in $out/opt/polymath/waylandMonitors/*/*.sh; do
      substituteInPlace "$script" \
        --replace-fail "#!/bin/bash" "#!${runtimeShell}"
    done

    mkdir -p $out/share/icons/hicolor/512x512/apps
    mv $out/share/pixmaps/polymath.png $out/share/icons/hicolor/512x512/apps/
    rmdir $out/share/pixmaps

    makeWrapper $out/opt/polymath/polymath $out/bin/polymath \
        --prefix PATH : ${
          lib.makeBinPath [
            coreutils
            gnugrep
            xprop
            curl
            dbus
            libsecret
          ]
        } \
        --prefix LD_LIBRARY_PATH : $out/opt/polymath/lib

    substituteInPlace $out/share/applications/com.fluxkeyboard.polymath.desktop \
      --replace-fail "Exec=/opt/polymath/polymath" "Exec=polymath" \
      --replace-fail "Icon=/usr/share/pixmaps/polymath.png" "Icon=polymath"

    runHook postInstall
  '';

  meta = {
    description = "Flux Keyboard Software";
    longDescription = "Software to configure and control the Flux Keyboard";
    homepage = "https://fluxkeyboard.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    mainProgram = "polymath";
    maintainers = with lib.maintainers; [
      darkjaguar91
      michailik
      BatteredBunny
    ];
    platforms = [ "x86_64-linux" ];
  };
})
