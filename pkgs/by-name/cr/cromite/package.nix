{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  patchelf,
  copyDesktopItems,
  makeDesktopItem,

  # Linked dynamic libraries.
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  gcc-unwrapped,
  gdk-pixbuf,
  glib,
  gtk3,
  gtk4,
  libdrm,
  libglvnd,
  libkrb5,
  libX11,
  libxcb,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libxkbcommon,
  libXrandr,
  libXrender,
  libXScrnSaver,
  libxshmfence,
  libXtst,
  libgbm,
  nspr,
  nss,
  pango,
  pipewire,
  vulkan-loader,
  wayland, # ozone/wayland

  # Command line programs
  coreutils,

  # Will crash without.
  systemd,

  # Loaded at runtime.
  libexif,
  pciutils,

  # Additional dependencies according to other distros.
  ## Ubuntu
  curl,
  liberation_ttf,
  util-linux,
  wget,
  xdg-utils,
  ## Arch Linux.
  flac,
  harfbuzz,
  icu,
  libopus,
  libpng,
  snappy,
  speechd-minimal,
  ## Gentoo
  bzip2,
  libcap,

  # Necessary for USB audio devices.
  libpulseaudio,
  pulseSupport ? true,

  adwaita-icon-theme,
  gsettings-desktop-schemas,

  # For video acceleration via VA-API (--enable-features=VaapiVideoDecoder)
  libva,
  libvaSupport ? true,

  # For Vulkan support (--enable-features=Vulkan)
  addDriverRunpath,

  # For QT support
  qt6,

  # command line arguments which are always set e.g "--disable-gpu"
  commandLineArgs ? "",
}:

let
  opusWithCustomModes = libopus.override { withCustomModes = true; };

  deps =
    [
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      bzip2
      cairo
      coreutils
      cups
      curl
      dbus
      expat
      flac
      fontconfig
      freetype
      gcc-unwrapped.lib
      gdk-pixbuf
      glib
      harfbuzz
      icu
      libcap
      libdrm
      liberation_ttf
      libexif
      libglvnd
      libkrb5
      libpng
      libX11
      libxcb
      libXcomposite
      libXcursor
      libXdamage
      libXext
      libXfixes
      libXi
      libxkbcommon
      libXrandr
      libXrender
      libXScrnSaver
      libxshmfence
      libXtst
      libgbm
      nspr
      nss
      opusWithCustomModes
      pango
      pciutils
      pipewire
      snappy
      speechd-minimal
      systemd
      util-linux
      vulkan-loader
      wayland
      wget
    ]
    ++ lib.optionals pulseSupport [ libpulseaudio ]
    ++ lib.optionals libvaSupport [ libva ]
    ++ [
      gtk3
      gtk4
      qt6.qtbase
      qt6.qtwayland
    ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "cromite";
  version = "137.0.7151.56";
  commit = "b4f8d96284c854cbe6448d2e30ee5a30ce3f0b82";

  src = fetchurl {
    url = "https://github.com/uazo/cromite/releases/download/v${finalAttrs.version}-${finalAttrs.commit}/chrome-lin64.tar.gz";
    hash = "sha256-f53Xh6xvk5Z8tkg/SUZS+plO3a7Qvn6ff2Soj7Dvvqw=";
  };

  # With strictDeps on, some shebangs were not being patched correctly
  # ie, $out/share/cromite/chrome
  strictDeps = false;

  nativeBuildInputs = [
    makeWrapper
    patchelf
    copyDesktopItems
  ];

  buildInputs = [
    # needed for XDG_ICON_DIRS
    adwaita-icon-theme
    glib
    gtk3
    gtk4
    # needed for GSETTINGS_SCHEMAS_PATH
    gsettings-desktop-schemas
  ];

  rpath = lib.makeLibraryPath deps + ":" + lib.makeSearchPathOutput "lib" "lib64" deps;

  binpath = lib.makeBinPath deps;

  desktopItems = [
    (makeDesktopItem {
      name = "cromite";
      exec = "cromite %U";
      icon = "cromite";
      genericName = "Cromite";
      desktopName = "Cromite";
      categories = [
        "Application"
        "Network"
        "WebBrowser"
      ];
    })
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 product_logo_48.png $out/share/pixmaps/cromite.png
    cp -v -a . $out/share/cromite
    # replace bundled vulkan-loader
    rm -v $out/share/cromite/libvulkan.so.1
    ln -v -s -t $out/share/cromite ${lib.getLib vulkan-loader}/lib/libvulkan.so.1
    # "--simulate-outdated-no-au" disables auto updates and browser outdated popup
    mkdir $out/bin
    makeWrapper $out/share/cromite/chrome $out/bin/cromite \
      --prefix QT_PLUGIN_PATH  : "${qt6.qtbase}/lib/qt-6/plugins:${qt6.qtwayland}/lib/qt-6/plugins" \
      --prefix NIXPKGS_QT6_QML_IMPORT_PATH : "${qt6.qtwayland}/lib/qt-6/qml" \
      --prefix LD_LIBRARY_PATH : "$rpath" \
      --prefix PATH            : "$binpath:${lib.makeBinPath [ xdg-utils ]}" \
      --prefix XDG_DATA_DIRS   : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH:${addDriverRunpath.driverLink}/share" \
      --set CHROME_WRAPPER  "cromite" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
      --add-flags "--simulate-outdated-no-au='Tue, 31 Dec 2099 23:59:59 GMT'" \
      --add-flags ${lib.escapeShellArg commandLineArgs}

    # Make sure that libGL and libvulkan are found by ANGLE libGLESv2.so
    patchelf --set-rpath $rpath $out/share/cromite/lib*GL*

    for elf in $out/share/cromite/{chrome,chrome_sandbox,chrome_crashpad_handler}; do
      patchelf --set-rpath $rpath $elf
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $elf
    done

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://github.com/uazo/cromite/releases";
    description = "Bromite fork with ad blocking and privacy enhancements";
    homepage = "https://github.com/uazo/cromite";
    license = with lib.licenses; [
      bsd3
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [ emaryn ];
    mainProgram = "cromite";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
