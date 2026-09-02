{
  bintools,
  fetchurl,
  lib,
  makeWrapper,
  patchelf,
  stdenvNoCC,
  testers,

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
  undmg,

  # Enables Chrome's "Use QT" appearance to introspect the user's Plasma theme
  plasmaSupport ? false,
  qt6,
  kdePackages,

  # Create a symlink at $out/bin/google-chrome
  withSymlink ? true,
}:

let
  pname = "google-chrome";

  opusWithCustomModes = libopus.override { withCustomModes = true; };

  deps = [
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
  ++ lib.optional pulseSupport libpulseaudio
  ++ lib.optional libvaSupport libva
  ++ [
    gtk3
    gtk4
  ]
  ++ lib.optionals plasmaSupport [
    qt6.qtbase
    qt6.qtwayland
    kdePackages.plasma-integration
    kdePackages.breeze
  ];

  linux = stdenvNoCC.mkDerivation (finalAttrs: {
    inherit pname meta;
    version = "152.0.7977.75";

    src =
      let
        debArch =
          {
            aarch64-linux = "arm64";
            x86_64-linux = "amd64";
          }
          .${stdenvNoCC.hostPlatform.system};
      in
      fetchurl {
        url = "https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${finalAttrs.version}-1_${debArch}.deb";
        hash =
          {
            amd64 = "sha256-oLemT3aP/A/1zMkmCtnrtT/Rb3oTHi42mU2li4LZE98=";
            arm64 = "sha256-OFS2UlA3+NKXBIEqJoGEnE7N9peXdQ2jdCOBQD834dI=";
          }
          .${debArch};
      };

    # With strictDeps on, some shebangs were not being patched correctly
    # ie, $out/share/google/chrome/google-chrome
    strictDeps = false;

    nativeBuildInputs = [
      makeWrapper
      patchelf
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

    unpackPhase = ''
      runHook preUnpack
      ${lib.getExe' bintools "ar"} x $src
      tar xf data.tar.xz
      runHook postUnpack
    '';

    rpath = lib.makeLibraryPath deps + ":" + lib.makeSearchPathOutput "lib" "lib64" deps;
    binpath = lib.makeBinPath deps;

    installPhase = ''
      runHook preInstall

      appname=chrome
      dist=stable

      exe=$out/bin/google-chrome-$dist

      mkdir -p $out/bin $out/share
      cp -v -a opt/* $out/share
      cp -v -a usr/share/* $out/share

      # replace bundled vulkan-loader
      rm -v $out/share/google/$appname/libvulkan.so.1
      ln -v -s -t "$out/share/google/$appname" "${lib.getLib vulkan-loader}/lib/libvulkan.so.1"

      substituteInPlace $out/share/google/$appname/google-$appname \
        --replace-fail 'CHROME_WRAPPER' 'WRAPPER'
      substituteInPlace $out/share/applications/com.google.Chrome.desktop \
        --replace-fail /usr/bin/google-chrome-$dist $exe
      substituteInPlace $out/share/applications/google-$appname.desktop \
        --replace-fail /usr/bin/google-chrome-$dist $exe
      substituteInPlace $out/share/gnome-control-center/default-apps/google-$appname.xml \
        --replace-fail /opt/google/$appname/google-$appname $exe

      for icon_file in $out/share/google/chrome*/product_logo_[0-9]*.png; do
        num_and_suffix="''${icon_file##*logo_}"
        if [ $dist = "stable" ]; then
          icon_size="''${num_and_suffix%.*}"
        else
          icon_size="''${num_and_suffix%_*}"
        fi
        logo_output_prefix="$out/share/icons/hicolor"
        logo_output_path="$logo_output_prefix/''${icon_size}x''${icon_size}/apps"
        mkdir -p "$logo_output_path"
        mv "$icon_file" "$logo_output_path/google-$appname.png"
      done

      # "--simulate-outdated-no-au" disables auto updates and browser outdated popup
      makeWrapper "$out/share/google/$appname/google-$appname" "$exe" \
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
        --set CHROME_WRAPPER  "google-chrome-$dist" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
        --add-flags "--simulate-outdated-no-au='Tue, 31 Dec 2099 23:59:59 GMT'" \
        --add-flags ${lib.escapeShellArg commandLineArgs}

      for elf in $out/share/google/$appname/{chrome,chrome-sandbox,chrome_crashpad_handler}; do
        patchelf --set-rpath $rpath $elf
        patchelf --set-interpreter ${bintools.dynamicLinker} $elf
      done

      runHook postInstall
    '';

    postInstall = lib.optionalString withSymlink ''
      ln -s $out/bin/google-chrome-stable $out/bin/google-chrome
    '';

    passthru = {
      updateScript = ./update.sh;
      tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
    };
  });

  darwin = stdenvNoCC.mkDerivation (finalAttrs: {
    inherit pname meta;
    version = "152.0.7977.76";

    src = fetchurl {
      url = "http://dl.google.com/release2/chrome/fwccdneh3i55zgoy366y75r2ya_152.0.7977.76/GoogleChrome-152.0.7977.76.dmg";
      hash = "sha256-VuYzRvaOH0YB/I1m1Agk+l4y4al1b4o4dZZnhm7J2PQ=";
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
      makeWrapper $out/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome $out/bin/google-chrome-stable \
        --add-flags "--simulate-outdated-no-au='Tue, 31 Dec 2099 23:59:59 GMT'" \
        --add-flags ${lib.escapeShellArg commandLineArgs}
      runHook postInstall
    '';

    postInstall = lib.optionalString withSymlink ''
      ln -s $out/bin/google-chrome-stable $out/bin/google-chrome
    '';

    passthru = {
      updateScript = ./update.sh;
      tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
    };
  });

  meta = {
    description = "Freeware web browser developed by Google";
    homepage = "https://www.google.com/chrome/browser/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      iedame
      mdaniels5757
    ];
    platforms = lib.platforms.darwin ++ [
      "aarch64-linux"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "google-chrome-stable";
  };
in
if stdenvNoCC.hostPlatform.isDarwin then
  darwin
else if stdenvNoCC.hostPlatform.isLinux then
  linux
else
  throw "Unsupported platform ${stdenvNoCC.hostPlatform.system}"
