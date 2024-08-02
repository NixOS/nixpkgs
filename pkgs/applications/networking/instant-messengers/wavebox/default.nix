{
  lib,
  stdenv,
  patchelf,
  makeWrapper,
  fetchurl,
  writeScript,

  # Libraries
  glib,
  fontconfig,
  freetype,
  pango,
  cairo,
  libX11,
  libXi,
  atk,
  nss,
  nspr,
  libXcursor,
  libXext,
  libXfixes,
  libXrender,
  libXScrnSaver,
  libXcomposite,
  libxcb,
  alsa-lib,
  libXdamage,
  libXtst,
  libXrandr,
  libxshmfence,
  expat,
  cups,
  dbus,
  gtk3,
  gtk4,
  gdk-pixbuf,
  gcc-unwrapped,
  at-spi2-atk,
  at-spi2-core,
  libkrb5,
  libdrm,
  libglvnd,
  mesa,
  libxkbcommon,
  pipewire,
  wayland,

  coreutils,

  # command line arguments which are always set e.g "--disable-gpu"
  commandLineArgs ? "",

  systemd,

  # Loaded at runtime.
  libexif,
  pciutils,

  liberation_ttf,
  curl,
  util-linux,
  xdg-utils,
  wget,
  flac,
  harfbuzz,
  icu,
  libpng,
  libopus,
  snappy,
  speechd,
  bzip2,
  libcap,

  # Necessary for USB audio devices.
  pulseSupport ? true,
  libpulseaudio,

  gsettings-desktop-schemas,

  # Allow video acceleration via VA-API to be disabled on systems where is doesn't
  # work reliably (--enable-features=VaapiVideoDecoder)
  libvaSupport ? true,
  libva,

  # For Vulkan support (--enable-features=Vulkan)
  addDriverRunpath,
}:

let
  opusWithCustomModes = libopus.override { withCustomModes = true; };

  deps =
    [
      glib
      fontconfig
      freetype
      pango
      cairo
      libX11
      libXi
      atk
      nss
      nspr
      libXcursor
      libXext
      libXfixes
      libXrender
      libXScrnSaver
      libXcomposite
      libxcb
      alsa-lib
      libXdamage
      libXtst
      libXrandr
      libxshmfence
      expat
      cups
      dbus
      gdk-pixbuf
      gcc-unwrapped.lib
      systemd
      libexif
      pciutils
      liberation_ttf
      curl
      util-linux
      wget
      flac
      harfbuzz
      icu
      libpng
      opusWithCustomModes
      snappy
      speechd
      bzip2
      libcap
      at-spi2-atk
      at-spi2-core
      libkrb5
      libdrm
      libglvnd
      mesa
      coreutils
      libxkbcommon
      pipewire
      wayland
    ]
    ++ lib.optional pulseSupport libpulseaudio
    ++ lib.optional libvaSupport libva
    ++ [
      gtk3
      gtk4
    ];

in
stdenv.mkDerivation (finalAttrs: {
  pname = "wavebox";
  version = "10.127.10-2";

  src = fetchurl {
    url = "https://download.wavebox.app/stable/linux/deb/amd64/wavebox_${finalAttrs.version}_amd64.deb";
    hash = "sha256-x095V2UhRJfPmmG+4/i7I9AnCU4WVrw0b71nEu73uew=";
  };

  nativeBuildInputs = [
    patchelf
    makeWrapper
  ];
  buildInputs = [
    gsettings-desktop-schemas # needed for GSETTINGS_SCHEMAS_PATH
    glib
    gtk3
  ];

  unpackPhase = ''
    ar x $src
    tar xf data.tar.xz
  '';

  rpath = lib.makeLibraryPath deps + ":" + lib.makeSearchPathOutput "lib" "lib64" deps;

  installPhase = ''
    runHook preInstall

    exe=$out/bin/wavebox

    mkdir -p $out/bin $out/share

    cp -a opt/* $out/share
    cp -a usr/share/* $out/share


    substituteInPlace $out/share/wavebox.io/wavebox/wavebox-launcher \
      --replace-fail 'CHROME_WRAPPER' 'WRAPPER'
    substituteInPlace $out/share/applications/wavebox.desktop \
      --replace-fail /opt/wavebox.io/wavebox/wavebox-launcher $exe
    substituteInPlace $out/share/menu/wavebox.menu \
      --replace-fail /opt $out/share \
      --replace-fail $out/share/wavebox.io/wavebox/wavebox $exe

    for icon_file in $out/share/wavebox.io/wavebox/product_logo_[0-9]*.png; do
      num_and_suffix="''${icon_file##*logo_}"
      icon_size="''${num_and_suffix%.*}"
      logo_output_prefix="$out/share/icons/hicolor"
      logo_output_path="$logo_output_prefix/''${icon_size}x''${icon_size}/apps"
      mkdir -p "$logo_output_path"
      mv "$icon_file" "$logo_output_path/wavebox.png"
    done

    makeWrapper "$out/share/wavebox.io/wavebox/wavebox" "$exe" \
      --prefix LD_LIBRARY_PATH : "$rpath" \
      --prefix PATH            : "${lib.makeBinPath deps}" \
      --suffix PATH            : "${lib.makeBinPath [ xdg-utils ]}" \
      --prefix XDG_DATA_DIRS   : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH:${addDriverRunpath.driverLink}/share" \
      --set CHROME_WRAPPER "wavebox" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --add-flags ${lib.escapeShellArg commandLineArgs}

    for elf in $out/share/wavebox.io/wavebox/{wavebox,chrome-sandbox,chrome_crashpad_handler}; do
      patchelf --set-rpath $rpath $elf
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $elf
    done

    runHook postInstall
  '';

  passthru = {
    updateScript = writeScript "update-wavebox.sh" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p nix-update curl jq

      version=$(curl "https://download.wavebox.app/stable/linux/latest.json" | jq --raw-output '.["urls"]["deb"] | match("https://download.wavebox.app/stable/linux/deb/amd64/wavebox_(.+)_amd64.deb").captures[0]["string"]')
      nix-update wavebox --version "$version"
    '';
  };

  meta = {
    description = "Wavebox Productivity Browser";
    homepage = "https://wavebox.io";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ flexiondotorg ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "wavebox";
  };
})
