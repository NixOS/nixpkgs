{
  stdenv,
  lib,
  dpkg,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  xorg,
  libva-minimal,
  xz,
  libva,
  libvdpau,
  libxkbcommon,
  wayland,
  libgcc,
  freetype,
  systemd,
  alsa-lib,
  fontconfig,
  pcre2,
  dbus,
}:
stdenv.mkDerivation {
  name = "boosteroid";
  version = "1.8.4";

  # They don't provide a way to download a specific version, and I didn't find developer contacts yet.
  src = fetchurl {
    url = "https://boosteroid.com/linux/installer/boosteroid-install-x64.deb";
    curlOpts = "--user-agent 'Mozilla/5.0'";
    hash = "sha256-JgQSoefjiLhwTj3Py9r8wnUgTUML5YQBVMumxCJ5+X8=";
  };
  unpackPhase = "dpkg-deb -x $src .";

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    # Mostly copied from autodiscovery script with some cleanup

    #  libva.so.2
    #  libva-drm.so.2
    libva-minimal

    xz #  liblzma.so.5
    libva #  libva-x11.so.2
    libvdpau #  libvdpau.so.1

    xorg.libXfixes #  libXfixes.so.3
    xorg.libXi #  libXi.so.6
    xorg.libX11 #  libX11-xcb.so.1
    xorg.xcbutilwm #  libxcb-icccm.so.4
    xorg.xcbutilimage #  libxcb-image.so.0
    xorg.xcbutilkeysyms #  libxcb-keysyms.so.1
    xorg.xcbutilrenderutil #  libxcb-render-util.so.0

    #  libxcb-xfixes.so.0
    #  libxcb-glx.so.0
    #  libxcb-shm.so.0
    #  libxcb-randr.so.0
    #  libxcb-render.so.0
    #  libxcb-shape.so.0
    #  libxcb-sync.so.1
    #  libxcb-xinerama.so.0
    #  libxcb-xkb.so.1
    #  libxcb-xinput.so.0
    #  libxcb.so.1
    xorg.libxcb
    #  libxkbcommon.so.0
    #  libxkbcommon-x11.so.0
    libxkbcommon

    xorg.libX11 #  libX11.so.6

    #  libwayland-client.so.0
    #  libwayland-cursor.so.0
    wayland

    libgcc.lib

    freetype #  libfreetype.so.6
    systemd #  libudev.so.1
    alsa-lib #  libasound.so.2
    fontconfig #  libfontconfig.so.1
    pcre2 #  libpcre2-16.so.0
    dbus.lib #  libdbus-1.so.3
  ];

  installPhase = ''
    mkdir -p $out/bin

    install -m755 "opt/BoosteroidGamesS.R.L./bin/Boosteroid" $out/bin/Boosteroid
    install -dm755 "$out/usr/share/applications"
    install -dm755 "$out/usr/share/icons/Boosteroid"
    install -m644 "usr/share/applications/Boosteroid.desktop" "$out/usr/share/applications/Boosteroid.desktop"
    install -m644 "usr/share/icons/Boosteroid/icon.svg" "$out/usr/share/icons/Boosteroid/icon.svg"

    substituteInPlace $out/usr/share/applications/Boosteroid.desktop \
      --replace "/opt/BoosteroidGamesS.R.L./bin/Boosteroid" "$out/bin/Boosteroid" \
      --replace "/usr/share/icons/Boosteroid/icon.svg" "$out/usr/share/icons/Boosteroid/icon.svg"

    # Doesn't work in Wayland — tries to call XGetKeyboardControl from libX11 and dumps stack.
    wrapProgram $out/bin/Boosteroid \
      --set QT_QPA_PLATFORM xcb
  '';

  meta = with lib; {
    homepage = "https://boosteroid.com/downloads/";
    description = "Boosteroid cloud gaming client";
    maintainers = with maintainers; [cab404];
    license = licenses.unfree;
    mainProgram = "Boosteroid";
    platforms = ["x86_64-linux"];
  };
}
