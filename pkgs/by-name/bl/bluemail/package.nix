{
  stdenv,
  lib,
  fetchurl,
  squashfsTools,
  autoPatchelfHook,
  copyDesktopItems,
  pango,
  gtk3,
  alsa-lib,
  nss,
  libXdamage,
  libdrm,
  libgbm,
  libxshmfence,
  makeDesktopItem,
  makeWrapper,
  wrapGAppsHook3,
  gcc-unwrapped,
  udev,
}:

stdenv.mkDerivation rec {
  pname = "bluemail";
  version = "1.140.93";

  # To update, check https://search.apps.ubuntu.com/api/v1/package/bluemail and copy the anon_download_url and version.
  src = fetchurl {
    url = "https://api.snapcraft.io/api/v1/snaps/download/ZVlj0qw0GOFd5JgTfL8kk2Y5eIG1IpiH_178.snap";
    hash = "sha512-xv7fn+VrtrxauejhgEMdTnmnDXb17TwanXZR6Lqfg5N40MbyDu76XQAWRB8xFU/+GdCTmjv47EaOC7SnnOw4EA==";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "bluemail";
      icon = "bluemail";
      exec = "bluemail";
      desktopName = "BlueMail";
      comment = meta.description;
      genericName = "Email Reader";
      mimeTypes = [
        "x-scheme-handler/me.blueone.linux"
        "x-scheme-handler/mailto"
        "x-scheme-handler/bluemail-notif"
      ];
      categories = [ "Office" ];
    })
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
    squashfsTools
    wrapGAppsHook3
  ];

  unpackPhase = ''
    runHook preUnpack

    unsquashfs $src

    runHook postUnpack
  '';

  sourceRoot = "squashfs-root";

  postPatch = ''
    rm -rf usr libEGL.so libGLESv2.so libvk_swiftshader.so libvulkan.so.1
  '';

  buildInputs = [
    pango
    gtk3
    alsa-lib
    nss
    libXdamage
    libdrm
    libgbm
    libxshmfence
    udev
  ];

  dontBuild = true;
  dontStrip = true;
  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,opt/bluemail}
    mv * $out/opt/bluemail
    ln -s $out/opt/bluemail/bluemail $out/bin/bluemail

    mkdir -p $out/share/icons/hicolor/1024x1024/apps
    ln -s $out/opt/bluemail/resources/assets/icons/bluemailx-icon.png $out/share/icons/hicolor/1024x1024/apps/bluemail.png

    runHook postInstall
  '';

  makeWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [
        gcc-unwrapped.lib
        gtk3
        udev
      ]
    }"
    "--prefix PATH : ${lib.makeBinPath [ stdenv.cc ]}"
  ];

  preFixup = ''
    wrapProgram $out/opt/bluemail/bluemail \
      ''${makeWrapperArgs[@]} \
      ''${gappsWrapperArgs[@]}
  '';

  meta = with lib; {
    description = "Cross platform email and calendar app, with AI features and a modern design";
    homepage = "https://bluemail.me";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    # Vendored copy of Electron.
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ ];
    mainProgram = "bluemail";
  };
}
