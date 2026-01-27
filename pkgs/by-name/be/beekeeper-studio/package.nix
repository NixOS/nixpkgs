{
  lib,
  stdenv,
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
  libxrandr,
  libxfixes,
  libxext,
  libxdamage,
  libxcomposite,
  libx11,
  libxcb,
  alsa-lib,
  expat,
  libxkbcommon,
  libgbm,
  vulkan-loader,
  systemd,
  libGL,
  krb5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "beekeeper-studio";
  version = "5.5.3";

  src =
    let
      selectSystem = attrs: attrs.${stdenv.hostPlatform.system};
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
        x86_64-linux = "sha256-zbOePN975TWp7zo3XagKYPjHPQiz3r6ui2fPfNEboGs=";
        aarch64-linux = "sha256-AoyaHBKO0gHgbq51D+OMH7SyUVnq2IjH4FIbeNepFHw=";
        x86_64-darwin = "sha256-GzK9fmhW86IKER1IPsLNDwyz03rKuqCTO+hcPR/2QnM=";
        aarch64-darwin = "sha256-pRBkgzp2w92/ACQaqpruwRtbfvg7f+nNE5rZ4YuQREc=";
      };
    };

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      dpkg
      autoPatchelfHook
      makeWrapper
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ unzip ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    (lib.getLib stdenv.cc.cc)
    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxcb
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

  runtimeDependencies = lib.optionals stdenv.hostPlatform.isLinux (lib.getLib systemd);

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    cp -r usr $out
    substituteInPlace $out/share/applications/beekeeper-studio.desktop \
      --replace-fail '"/opt/Beekeeper Studio/beekeeper-studio"' "beekeeper-studio"
    mkdir -p $out/opt $out/bin
    cp -r opt/"Beekeeper Studio" $out/opt/beekeeper-studio
    makeWrapper $out/opt/beekeeper-studio/beekeeper-studio-bin $out/bin/beekeeper-studio \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications" "$out/bin"
    cp -R . "$out/Applications/Beekeeper Studio.app"
    # Create a launcher script to run from the command line
    cat > "$out/bin/beekeeper-studio" << EOF
    #!${runtimeShell}
    open -na "$out/Applications/Beekeeper Studio.app" --args "\$@"
    EOF
    chmod +x "$out/bin/beekeeper-studio"
  ''
  + ''
    runHook postInstall
  '';

  dontFixup = stdenv.hostPlatform.isDarwin;

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
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
    knownVulnerabilities = [ "Electron version 32 is EOL" ];
  };
})
