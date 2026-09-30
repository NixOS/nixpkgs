{
  lib,
  stdenv,
  fetchurl,
  addDriverRunpath,
  autoPatchelfHook,
  dpkg,
  makeShellWrapper,
  wrapGAppsHook3,
  alsa-lib,
  atk,
  cups,
  dbus,
  expat,
  glib,
  gtk3,
  libdrm,
  libgbm,
  libglvnd,
  libpulseaudio,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  mesa,
  nspr,
  nss,
  systemdLibs,
  udev,
  wayland,
  xdg-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "boundary-desktop";
  version = "2.6.3";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://releases.hashicorp.com/boundary-desktop/${finalAttrs.version}/boundary-desktop_${finalAttrs.version}_amd64.deb";
    hash = "sha256-8y3Upel6I8b7twWa+LhgzMTqw1kkutsCeqMx4uwlqQc=";
  };

  nativeBuildInputs = [
    addDriverRunpath
    autoPatchelfHook
    dpkg
    makeShellWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    atk
    cups
    dbus
    expat
    glib
    gtk3
    libdrm
    libpulseaudio
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    mesa
    nspr
    nss
    udev
  ];

  dontUnpack = true;
  dontBuild = true;
  dontPatchELF = true;
  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    dpkg --fsys-tarfile $src | tar --extract
    rm -rf usr/share/lintian usr/share/doc

    mkdir -p $out
    mv usr/* $out/
    rmdir usr

    chmod -R g-w $out

    mkdir -p $out/share/icons/hicolor/256x256/apps
    mv $out/share/pixmaps/boundary-desktop.png $out/share/icons/hicolor/256x256/apps/
    rmdir $out/share/pixmaps || true

    runHook postInstall
  '';

  # The .deb ships bin/boundary-desktop as a symlink and a setuid chrome-sandbox the Nix
  # store cannot keep, so the launcher is replaced by a wrapper that disables the sandbox.
  postFixup = ''
    rm $out/bin/boundary-desktop
    makeShellWrapper $out/lib/boundary-desktop/boundary-desktop $out/bin/boundary-desktop \
      "''${gappsWrapperArgs[@]}" \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]} \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          systemdLibs
          libglvnd
          mesa
          libgbm
          wayland
        ]
      } \
      --prefix LD_LIBRARY_PATH : $out/lib/boundary-desktop:${addDriverRunpath.driverLink}/lib \
      --suffix VK_ADD_DRIVER_FILES : "${addDriverRunpath.driverLink}/share/vulkan/icd.d" \
      --add-flags "--no-sandbox --disable-gpu-sandbox" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer --enable-wayland-ime=true}}"
  '';

  meta = {
    description = "Desktop client for HashiCorp Boundary";
    homepage = "https://www.boundaryproject.io";
    license = lib.licenses.bsl11;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ cRolandoJr ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "boundary-desktop";
  };
})
