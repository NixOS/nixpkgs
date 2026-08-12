{
  lib,
  stdenvNoCC,
  fetchurl,
  dpkg,
  buildFHSEnvBubblewrap,
  glib,
  zlib,
  expat,
  fontconfig,
  freetype,
  nspr,
  nss,
  libx11,
  libxext,
  libxdamage,
  libxfixes,
  libxrandr,
  libxcomposite,
  libxcursor,
  libxi,
  libxtst,
  libxscrnsaver,
  libxkbfile,
  libxcb,
  libxcb-util,
  libxcb-cursor,
  libxcb-image,
  libxcb-keysyms,
  libxcb-render-util,
  libxcb-wm,
  libxkbcommon,
  mesa,
  libGL,
  libdrm,
  libgbm,
  alsa-lib,
  pulseaudio,
  pipewire,
  libgcrypt,
  libgpg-error,
  gdk-pixbuf,
  libnotify,
  dbus,
  hicolor-icon-theme,
  shared-mime-info,
  gtk3,
}:

let
  version = "26.26.0";

  src = fetchurl {
    url = "https://download.max.ru/linux/deb/pool/main/m/max/MAX-26.26.0.76189.deb";
    hash = "sha256-4xRS8Z6VJKVBAMmtgOL/LAjKsdLPtV0qrI8immA9UAM=";
  };

  runtimePkgs = [
    glib
    zlib
    expat
    fontconfig
    freetype

    nspr
    nss

    libx11
    libxext
    libxdamage
    libxfixes
    libxrandr
    libxcomposite
    libxcursor
    libxi
    libxtst
    libxscrnsaver
    libxkbfile

    libxcb
    libxcb-util
    libxcb-cursor
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxcb-wm

    libxkbcommon

    mesa
    libGL
    libdrm
    libgbm

    alsa-lib
    pulseaudio
    pipewire

    libgcrypt
    libgpg-error

    gdk-pixbuf
    libnotify
    dbus

    hicolor-icon-theme
    shared-mime-info
    gtk3
  ];

  maxApp = stdenvNoCC.mkDerivation {
    pname = "max-app";
    inherit version src;

    nativeBuildInputs = [ dpkg ];

    unpackPhase = ''
      mkdir unpacked
      dpkg -x "$src" unpacked
    '';

    installPhase = ''
      mkdir -p "$out/share"
      cp -r unpacked/usr/share/max "$out/share/max"
    '';

    dontStrip = true;
  };

  maxFhs = buildFHSEnvBubblewrap {
    name = "max";

    targetPkgs = _: runtimePkgs;
    multiPkgs = _: runtimePkgs;

    unshareUser = false;
    chdirToPwd = false;

    extraPreBwrapCmds = ''
      mkdir -p "$HOME"
      mkdir -p "$XDG_RUNTIME_DIR"
    '';

    profile = ''
      export LD_LIBRARY_PATH="${lib.makeLibraryPath runtimePkgs}:${maxApp}/share/max/lib64:${maxApp}/share/max/bin/max-service/lib64:/usr/lib64:/usr/lib:$LD_LIBRARY_PATH"
      export QT_QPA_PLATFORM=xcb
      export QT_X11_NO_MITSHM=1
      export XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
    '';

    runScript = "${maxApp}/share/max/bin/max";
  };

in
stdenvNoCC.mkDerivation {
  pname = "max";
  strictDeps = true;
  __structuredAttrs = true;
  inherit version;

  dontUnpack = true;

  installPhase = ''
        runHook preInstall

        mkdir -p "$out/bin"
        mkdir -p "$out/share/applications"

        ln -s ${maxFhs}/bin/max "$out/bin/max"

        cat > "$out/share/applications/max.desktop" <<EOF_DESKTOP
    [Desktop Entry]
    Name=MAX
    Comment=Messaging application
    Exec=$out/bin/max
    Terminal=false
    Type=Application
    Categories=Network;InstantMessaging;
    EOF_DESKTOP

        runHook postInstall
  '';

  meta = {
    description = "Messaging application";
    homepage = "https://max.ru/";
    downloadPage = "https://download.max.ru/";
    license = lib.licenses.unfree;
    mainProgram = "max";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
