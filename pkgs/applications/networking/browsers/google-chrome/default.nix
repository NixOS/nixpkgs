{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  wrapGAppsHook3,
  dpkg,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libX11,
  libXScrnSaver,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXrandr,
  libXrender,
  libXtst,
  libdrm,
  libuuid,
  libxkbcommon,
  libxshmfence,
  libgbm,
  nspr,
  nss,
  pango,
  udev,
  xorg,
  zlib,
  xdg-utils,
  libGL,
  libGLU,
  vulkan-loader,
  wayland,
}:

let
  # Define the runtime library path just like Brave does
  deps = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libxshmfence
    libXtst
    libuuid
    libgbm
    libxkbcommon
    libdrm
    nspr
    nss
    pango
    udev
    xorg.libxcb
    zlib
    libGL
    libGLU
    vulkan-loader
    wayland
  ];
  rpath = lib.makeLibraryPath deps;
in
stdenv.mkDerivation rec {
  pname = "google-chrome";
  version = "stable";

  src = fetchurl {
    url = "https://dl.google.com/linux/direct/google-chrome-${version}_current_amd64.deb";
    sha256 = "sha256-VNvx/3l3gzj8HjeeK3v/Hj05E9t2PvsiP8pnIOq1AEA=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
  ];

  unpackPhase = ''
    # Extract the .deb archive manually to bypass SUID permission errors
    ar x $src
    mkdir unpacked
    tar -xvf data.tar.xz \
      --no-same-owner \
      --no-same-permissions \
      -C unpacked
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/opt/google/chrome $out/share

    # Copy everything from the unpacked deb
    cp -r unpacked/opt/google/chrome/* $out/opt/google/chrome/
    cp -r unpacked/usr/share/* $out/share/

    # 1. Patch the desktop files
    # Chrome's desktop files usually use 'google-chrome-stable'
    # We replace the absolute path and the command name
    for desktopFile in $out/share/applications/*.desktop; do
      substituteInPlace "$desktopFile" \
        --replace-fail "/usr/bin/google-chrome-stable" "$out/bin/google-chrome" \
        --replace-quiet "Exec=google-chrome-stable" "Exec=google-chrome"
    done

    # 2. Fix scripts (like the 'google-chrome' wrapper script)
    patchShebangs $out/opt/google/chrome/

    # 3. Patch the ACTUAL binary (chrome), not the script (google-chrome)
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${rpath}" \
      $out/opt/google/chrome/chrome

    # 4. Handle additional shared libraries in the chrome folder
    # Some internal libs like libvulkan.so need the rpath too
    for lib in $out/opt/google/chrome/*.so*; do
      if [ -f "$lib" ]; then
        patchelf --set-rpath "${rpath}" "$lib" || true
      fi
    done

    chmod 4755 $out/opt/google/chrome/chrome-sandbox || true

    runHook postInstall
  '';

  preFixup = ''
    # Add Wayland and feature flags similar to Brave
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : ${rpath}
      --prefix PATH : ${lib.makeBinPath [ xdg-utils ]}
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto}}"
    )
  '';

  postFixup = ''
    ln -sf $out/opt/google/chrome/google-chrome $out/bin/google-chrome

    # Optional: Ensure the icon is in a place NixOS looks for it
    mkdir -p $out/share/pixmaps
    ln -s $out/opt/google/chrome/product_logo_256.png $out/share/pixmaps/google-chrome.png
  '';
}
