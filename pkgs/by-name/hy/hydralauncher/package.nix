{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  makeWrapper,
  glibc,
  glib,
  nss,
  nspr,
  dbus,
  at-spi2-atk,
  at-spi2-core,
  cups,
  libdrm,
  gtk3,
  pango,
  cairo,
  xorg,
  mesa,
  expat,
  libxkbcommon,
  alsa-lib,
  libgcc,
  libGL,
  swiftshader,
  vulkan-loader,
  xdg-utils,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hydralauncher";
  version = "2.1.7";

  src = fetchurl {
    url = "https://github.com/hydralauncher/hydra/releases/download/v${finalAttrs.version}/hydralauncher_${finalAttrs.version}_amd64.deb";
    hash = "sha256-ycayRFQnddr3pheflEGK/1rzy2BVA5nyYMm/Fu8wF2M=";
  };

  dontBuild = true;

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  buildInputs = [
    glibc
    glib
    nss
    nspr
    dbus
    at-spi2-atk
    at-spi2-core
    cups
    libdrm
    gtk3
    pango
    cairo
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    mesa
    expat
    xorg.libxcb
    libxkbcommon
    alsa-lib
    libgcc
    libGL
    swiftshader
    vulkan-loader
  ];

  unpackPhase = ''
    runHook preUnpack

    dpkg-deb -x $src .

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{share,bin,libexec}
    cp -r opt/Hydra $out/libexec
    ln -s $out/libexec/Hydra/hydralauncher $out/bin/hydralauncher
    cp -r usr/share $out

    substituteInPlace $out/share/applications/hydralauncher.desktop \
      --replace /opt/Hydra/hydralauncher $out/bin/hydralauncher

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/hydralauncher \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs}:$out/libexec/Hydra \
      --prefix PATH : ${lib.makeBinPath [ xdg-utils ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Game launcher with its own embedded bittorrent client";
    homepage = "https://github.com/hydralauncher/hydra";
    changelog = "https://github.com/hydralauncher/hydra/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    mainProgram = "hydralauncher";
    platforms = lib.platforms.linux;
    # It is installed as a binary, because if it was built from source, it wouldn't have game icons, because a SteamGridDB API key is needed to download them
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
