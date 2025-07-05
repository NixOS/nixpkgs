{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  dpkg,
  unzip,
  autoPatchelfHook,
  makeWrapper,
  runtimeShell,
  glibc,
  gcc,
  glib,
  gtk3,
  pango,
  cairo,
  dbus,
  at-spi2-atk,
  cups,
  libdrm,
  gdk-pixbuf,
  nss,
  nspr,
  xorg,
  alsa-lib,
  expat,
  libxkbcommon,
  libgbm,
  vulkan-loader,
  systemd,
  libGL,
  krb5,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "beekeeper-studio";
  version = "5.2.12";

  src =
    let
      selectSystem = attrs: attrs.${stdenvNoCC.hostPlatform.system};
      asset = selectSystem {
        x86_64-linux = "beekeeper-studio_${finalAttrs.version}_amd64.deb";
        aarch64-linux = "beekeeper-studio_${finalAttrs.version}_arm64.deb";
        x86_64-darwin = "Beekeeper-Studio-${finalAttrs.version}-mac.zip";
        aarch64-darwin = "Beekeeper-Studio-${finalAttrs.version}-arm64-mac.zip";
      };
    in
    fetchurl {
      url = "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${finalAttrs.version}/${asset}";
      hash = selectSystem {
        x86_64-linux = "sha256-hpzvu4SyVLXhQ5wbh5hyx+8tM19SxkKZvlMVhzhDCW4=";
        aarch64-linux = "sha256-s567NOTzTItfOdsABIzYoF8iYSpwDsDzbnLZhUSfT8o=";
        x86_64-darwin = "sha256-4mNb6OjluCVHfGCW8dmfpPKayR8pesAqTRCjHJCPfpE=";
        aarch64-darwin = "sha256-wfDeMS6UuG87+VmONSx8DuBm+xFTVscA2EDAcUQu6og=";
      };
    };

  nativeBuildInputs =
    lib.optionals stdenvNoCC.hostPlatform.isLinux [
      dpkg
      autoPatchelfHook
      makeWrapper
    ]
    ++ lib.optionals stdenvNoCC.hostPlatform.isDarwin [ unzip ];

  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    (lib.getLib stdenv.cc.cc)
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb
    libxkbcommon
    glibc
    gcc
    libGL
    glib
    gtk3
    pango
    cairo
    dbus
    at-spi2-atk
    cups
    libdrm
    gdk-pixbuf
    nss
    nspr
    alsa-lib
    expat
    libgbm
    vulkan-loader
    krb5
  ];

  runtimeDependencies = lib.optionals stdenvNoCC.hostPlatform.isLinux (map lib.getLib [ systemd ]);

  installPhase = ''
    runHook preInstall

    ${lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
      cp -r usr $out
      substituteInPlace $out/share/applications/beekeeper-studio.desktop \
        --replace-fail '"/opt/Beekeeper Studio/beekeeper-studio"' "beekeeper-studio"
      mkdir -p $out/opt $out/bin
      cp -r opt/"Beekeeper Studio" $out/opt/beekeeper-studio
      makeWrapper $out/opt/beekeeper-studio/beekeeper-studio-bin $out/bin/beekeeper-studio \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
    ''}
    ${lib.optionalString stdenvNoCC.hostPlatform.isDarwin (
      ''
        mkdir -p "$out/Applications" "$out/bin"
        cp -R . "$out/Applications/Beekeeper Studio.app"
      ''
      +
        # Create a launcher script to run from the command line
        ''
          cat > "$out/bin/beekeeper-studio" << EOF
          #!${runtimeShell}
          open -na "$out/Applications/Beekeeper Studio.app" --args "\$@"
          EOF
          chmod +x "$out/bin/beekeeper-studio"
        ''
    )}

    runHook postInstall
  '';

  dontFixup = stdenvNoCC.hostPlatform.isDarwin;

  preFixup = lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
    patchelf --add-needed libGL.so.1 \
      --add-needed libEGL.so.1 \
      --add-rpath ${
        lib.makeLibraryPath [
          libGL
        ]
      } $out/opt/beekeeper-studio/beekeeper-studio-bin
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Modern and easy to use SQL client for MySQL, Postgres, SQLite, SQL Server, and more";
    homepage = "https://www.beekeeperstudio.io";
    changelog = "https://github.com/beekeeper-studio/beekeeper-studio/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "beekeeper-studio";
    maintainers = with lib.maintainers; [
      milogert
      alexnortung
      iamanaws
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    knownVulnerabilities = [ "Electron version 31 is EOL" ];
  };
})
