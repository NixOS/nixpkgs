{ stdenv
, lib
, makeWrapper
, wrapGAppsHook
, patchelf
, dpkg
, xorg
, atk
, glib
, pango
, gdk-pixbuf
, cairo
, freetype
, fontconfig
, gtk3
, dbus
, nss
, nspr
, alsa-lib
, cups
, expat
, udev
, libnotify
, xdg-utils
, mesa
, libappindicator-gtk3
, libdrm
, libGL
, libxkbcommon
, wayland
, pipewire
}:

# Helper function for building a derivation for Franz and forks.

{ pname, name, version, src, meta, extraBuildInputs ? [], commandLineArgs ? "" }:

stdenv.mkDerivation rec {
  inherit pname version src meta;

  # Don't remove runtime deps.
  dontPatchELF = true;
  dontStrip = true;

  nativeBuildInputs = [ patchelf (wrapGAppsHook.override { inherit makeWrapper; }) dpkg ];
  buildInputs = extraBuildInputs ++ (with xorg; [
    libXi
    libXcursor
    libXdamage
    libXrandr
    libXcomposite
    libXext
    libXfixes
    libXrender
    libX11
    libXtst
    libXScrnSaver
    libxcb
    libxkbcommon
    libdrm
    libGL
  ]) ++ [
    mesa #libgbm
    gtk3
    atk
    glib
    pango
    gdk-pixbuf
    cairo
    freetype
    fontconfig
    dbus
    nss
    nspr
    alsa-lib
    cups
    expat
    stdenv.cc.cc
    wayland
    pipewire
  ];

  runtimeDependencies = [ stdenv.cc.cc.lib (lib.getLib udev) libnotify libappindicator-gtk3 ];
  libPath = lib.makeLibraryPath buildInputs
    + lib.optionalString (stdenv.is64bit)
    (":" + lib.makeSearchPathOutput "lib" "lib64" buildInputs)
    + (":" + lib.makeSearchPath "opt/${name}" [ "$out" ])
    + (":" + lib.makeLibraryPath runtimeDependencies);
  binpath = lib.makeBinPath buildInputs;

  unpackPhase = "dpkg-deb -x $src .";

  buildPhase = ''
    runHook preBuild
    for f in chrome_crashpad_handler ${pname} chrome-sandbox ; do
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath}" \
        opt/${name}/$f
    done
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -r opt $out
    ln -s $out/opt/${name}/${pname} $out/bin

    # Provide desktop item and icon.
    cp -r usr/share $out
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace /opt/${name}/${pname} ${pname}
    runHook postInstall
  '';

  preFixup = ''
    # Add command line args to wrapGApp.
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : ${libPath}
      --prefix PATH : ${binpath}
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}} ${lib.escapeShellArg commandLineArgs}"
    )
  '';
}
