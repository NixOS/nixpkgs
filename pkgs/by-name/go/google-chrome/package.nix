{
  fetchurl,
  lib,
  makeWrapper,
  patchelf,
  stdenv,
  stdenvNoCC,

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
  mesa,
  nspr,
  nss,
  pango,
  pipewire,
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
  speechd,
  ## Gentoo
  bzip2,
  libcap,

  # Necessary for USB audio devices.
  libpulseaudio,
  pulseSupport ? true,

  gnome,
  gsettings-desktop-schemas,

  # For video acceleration via VA-API (--enable-features=VaapiVideoDecoder)
  libva,
  libvaSupport ? true,

  # For Vulkan support (--enable-features=Vulkan)
  addOpenGLRunpath,
  undmg,
}:

let
  pname = "google-chrome";

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
      mesa
      nspr
      nss
      opusWithCustomModes
      pango
      pciutils
      pipewire
      snappy
      speechd
      systemd
      util-linux
      wayland
      wget
    ]
    ++ lib.optional pulseSupport libpulseaudio
    ++ lib.optional libvaSupport libva
    ++ [
      gtk3
      gtk4
    ];

  linux = stdenv.mkDerivation (finalAttrs: {
    inherit pname meta passthru;
    version = "128.0.6613.84";

    src = fetchurl {
      url = "https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${finalAttrs.version}-1_amd64.deb";
      hash = "sha256-4hABtHDq/8lIP6YbpU1VJdmgZNmLN2qb0VMPYw3dsBg=";
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
      gnome.adwaita-icon-theme
      glib
      gtk3
      gtk4
      # needed for GSETTINGS_SCHEMAS_PATH
      gsettings-desktop-schemas
    ];

    unpackPhase = ''
      runHook preUnpack
      ar x $src
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

      cp -a opt/* $out/share
      cp -a usr/share/* $out/share

      substituteInPlace $out/share/google/$appname/google-$appname \
        --replace-fail 'CHROME_WRAPPER' 'WRAPPER'
      substituteInPlace $out/share/applications/google-$appname.desktop \
        --replace-fail /usr/bin/google-chrome-$dist $exe
      substituteInPlace $out/share/gnome-control-center/default-apps/google-$appname.xml \
        --replace-fail /opt/google/$appname/google-$appname $exe
      substituteInPlace $out/share/menu/google-$appname.menu \
        --replace-fail /opt $out/share \
        --replace-fail $out/share/google/$appname/google-$appname $exe

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

      makeWrapper "$out/share/google/$appname/google-$appname" "$exe" \
        --prefix LD_LIBRARY_PATH : "$rpath" \
        --prefix PATH            : "$binpath" \
        --suffix PATH            : "${lib.makeBinPath [ xdg-utils ]}" \
        --prefix XDG_DATA_DIRS   : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH:${addOpenGLRunpath.driverLink}/share" \
        --set CHROME_WRAPPER  "google-chrome-$dist" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
        --add-flags ${lib.escapeShellArg commandLineArgs}

      for elf in $out/share/google/$appname/{chrome,chrome-sandbox,chrome_crashpad_handler}; do
        patchelf --set-rpath $rpath $elf
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $elf
      done

      runHook postInstall
    '';
  });

  darwin = stdenvNoCC.mkDerivation (finalAttrs: {
    inherit pname meta passthru;
    version = "128.0.6613.85";

    src = fetchurl {
      url = "http://dl.google.com/release2/chrome/adnfqet5f4kxrux64zb25vwits5a_128.0.6613.85/GoogleChrome-128.0.6613.85.dmg";
      hash = "sha256-mWTNwfMfCLPV+w1VCMUdv7lFtYSEVr4mnDgKURlDV3Q=";
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
      makeWrapper $out/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome $out/bin/google-chrome-stable \
        --add-flags ${lib.escapeShellArg commandLineArgs}

      runHook postInstall
    '';
  });

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://chromereleases.googleblog.com/";
    description = "Freeware web browser developed by Google";
    homepage = "https://www.google.com/chrome/browser/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      jnsgruk
      johnrtitor
    ];
    platforms = lib.platforms.darwin ++ [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "google-chrome-stable";
  };
in
if stdenvNoCC.isDarwin then darwin else linux
