{
  bintools,
  fetchurl,
  lib,
  makeWrapper,
  patchelf,
  stdenvNoCC,
  testers,
  dpkg,

  # Linked dynamic libraries
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
  libx11,
  libxcb,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxkbcommon,
  libxrandr,
  libxrender,
  libxscrnsaver,
  libxshmfence,
  libxtst,
  libgbm,
  nspr,
  nss,
  pango,
  pipewire,
  vulkan-loader,
  wayland, # ozone/wayland

  # Command line programs
  coreutils,

  # command line arguments which are always set e.g "--disable-gpu"
  commandLineArgs ? "",

  # Will crash without.
  systemd,

  # Loaded at runtime.
  libexif,
  pciutils,

  # Additional dependencies according to other distros
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
  undmg,

  # Enables Edge's "Use QT" appearance to introspect the user's Plasma theme
  plasmaSupport ? false,
  qt6,
  kdePackages,

  # Edge Specific and AAD sync
  cacert,
  libsecret,
  libuuid,

  # Create a symlink at $out/bin/microsoft-edge-stable
  withSymlink ? true,
}:

let
  pname = "microsoft-edge";
  opusWithCustomModes = libopus.override { withCustomModes = true; };

  deps = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    bzip2
    cacert
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
    gtk3
    gtk4
    harfbuzz
    icu
    libcap
    libdrm
    liberation_ttf
    libexif
    libgbm
    libglvnd
    libkrb5
    libpng
    libsecret
    libuuid
    libx11
    libxcb
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxkbcommon
    libxrandr
    libxrender
    libxscrnsaver
    libxshmfence
    libxtst
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
  ++ lib.optional pulseSupport libpulseaudio
  ++ lib.optional libvaSupport libva
  ++ lib.optionals plasmaSupport [
    qt6.qtbase
    qt6.qtwayland
    kdePackages.plasma-integration
    kdePackages.breeze
  ];

  linux = stdenvNoCC.mkDerivation (finalAttrs: {
    inherit pname meta;
    version = "154.0.4258.37";

    src = fetchurl {
      url = "https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_${finalAttrs.version}-1_amd64.deb";
      hash = "sha256-xvopdHM5kTIbRsQGS3hc3sWhTYzd0YK8X9oFfjfnYD0=";
    };

    # With strictDeps on, some shebangs were not being patched correctly
    # ie, $out/share/microsoft/msedge/microsoft-edge
    strictDeps = false;

    nativeBuildInputs = [
      makeWrapper
      patchelf
      dpkg
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

    installPhase = ''
      runHook preInstall

      appname=msedge
      dist=stable

      exe=$out/bin/microsoft-edge-$dist

      mkdir -p $out/bin $out/share
      cp -v -a opt/* $out/share
      cp -v -a usr/share/* $out/share

      # replace bundled vulkan-loader
      rm -v $out/share/microsoft/$appname/libvulkan.so.1
      ln -v -s -t "$out/share/microsoft/$appname" "${lib.getLib vulkan-loader}/lib/libvulkan.so.1"

      substituteInPlace $out/share/microsoft/$appname/microsoft-edge \
        --replace-fail 'CHROME_WRAPPER' 'WRAPPER'
      substituteInPlace $out/share/applications/microsoft-edge.desktop \
        --replace-fail /usr/bin/microsoft-edge-$dist $exe
      substituteInPlace $out/share/applications/com.microsoft.Edge.desktop \
        --replace-fail /usr/bin/microsoft-edge-$dist $exe
      substituteInPlace $out/share/gnome-control-center/default-apps/microsoft-edge.xml \
        --replace-fail /opt/microsoft/$appname $exe

      for icon_file in $out/share/microsoft/msedge/product_logo_[0-9]*.png; do
        num_and_suffix="''${icon_file##*logo_}"
        if [ $dist = "stable" ]; then
          icon_size="''${num_and_suffix%.*}"
        else
          icon_size="''${num_and_suffix%_*}"
        fi
        logo_output_prefix="$out/share/icons/hicolor"
        logo_output_path="$logo_output_prefix/''${icon_size}x''${icon_size}/apps"
        mkdir -p "$logo_output_path"
        mv "$icon_file" "$logo_output_path/microsoft-edge.png"
      done

      # "--simulate-outdated-no-au" disables auto updates and browser outdated popup
      makeWrapper "$out/share/microsoft/$appname/microsoft-edge" "$exe" \
        ${lib.optionalString plasmaSupport ''
          --prefix QT_PLUGIN_PATH  : "${qt6.qtbase}/lib/qt-6/plugins" \
          --prefix QT_PLUGIN_PATH  : "${qt6.qtwayland}/lib/qt-6/plugins" \
          --prefix QT_PLUGIN_PATH  : "${kdePackages.plasma-integration}/lib/qt-6/plugins" \
          --prefix QT_PLUGIN_PATH  : "${kdePackages.breeze}/lib/qt-6/plugins" \
          --prefix NIXPKGS_QT6_QML_IMPORT_PATH : "${qt6.qtwayland}/lib/qt-6/qml" \
        ''} \
        --prefix LD_LIBRARY_PATH : "$rpath" \
        --prefix PATH            : "$binpath" \
        --suffix PATH            : "${lib.makeBinPath [ xdg-utils ]}" \
        --prefix XDG_DATA_DIRS   : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH:${addDriverRunpath.driverLink}/share" \
        --set SSL_CERT_FILE "${cacert}/etc/ssl/certs/ca-bundle.crt" \
        --set CHROME_WRAPPER  "microsoft-edge-$dist" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
        --add-flags "--simulate-outdated-no-au='Tue, 31 Dec 2099 23:59:59 GMT'" \
        --add-flags ${lib.escapeShellArg commandLineArgs}

      # Edge specific set liboneauth
      patchelf --set-rpath $rpath $out/share/microsoft/$appname/liboneauth.so

      for elf in $out/share/microsoft/$appname/{msedge,msedge-sandbox,msedge_crashpad_handler}; do
        patchelf --set-rpath $rpath $elf
        patchelf --set-interpreter ${bintools.dynamicLinker} $elf
      done

      runHook postInstall
    '';

    postInstall = lib.optionalString withSymlink ''
      ln -s $out/bin/microsoft-edge-stable $out/bin/microsoft-edge
    '';

    passthru = {
      updateScript = ./update.sh;
      tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
    };
  });

  darwin = stdenvNoCC.mkDerivation (finalAttrs: {
    inherit pname meta;
    version = "154.0.4258.37";
    uuid = "f7dec597-801d-4c4b-ae51-c8a53c78925c";

    src = fetchurl {
      url = "https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/${finalAttrs.uuid}/MicrosoftEdge-${finalAttrs.version}.dmg";
      hash = "sha256-R385aGFby0WK64wxHGCbKnDymsUIG+lzTpQfVO2NBgA=";
    };

    dontPatch = true;
    dontConfigure = true;
    dontBuild = true;
    dontFixup = true;

    nativeBuildInputs = [
      makeWrapper
      undmg
    ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r *.app $out/Applications

      mkdir -p $out/bin

      # "--simulate-outdated-no-au" disables auto updates and browser outdated popup
      makeWrapper $out/Applications/Microsoft\ Edge.app/Contents/MacOS/Microsoft\ Edge $out/bin/microsoft-edge-stable \
        --add-flags "--simulate-outdated-no-au='Tue, 31 Dec 2099 23:59:59 GMT'" \
        --add-flags ${lib.escapeShellArg commandLineArgs}
      runHook postInstall
    '';

    postInstall = lib.optionalString withSymlink ''
      ln -s $out/bin/microsoft-edge-stable $out/bin/microsoft-edge
    '';

    passthru = {
      updateScript = ./update.sh;
      tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
    };
  });

  meta = {
    description = "Web browser from Microsoft";
    homepage = "https://www.microsoft.com/en-us/edge";
    changelog = "https://learn.microsoft.com/en-us/deployedge/microsoft-edge-relnote-stable-channel";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      cholli
      ulrikstrid
      maeve-oake
      leleuvilela
      jonhermansen
      iedame
    ];
    platforms = lib.platforms.darwin ++ [
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "microsoft-edge-stable";
  };

in
if stdenvNoCC.hostPlatform.isDarwin then
  darwin
else if stdenvNoCC.hostPlatform.isLinux then
  linux
else
  throw "Unsupported platform ${stdenvNoCC.hostPlatform.system}"
