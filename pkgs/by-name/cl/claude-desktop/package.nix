{
  lib,
  fetchurl,
  stdenvNoCC,

  ### Tools
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  wrapGAppsHook3,

  ### Electron/Chromium
  nss,
  nspr,
  mesa,
  alsa-lib,
  libxkbcommon,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  at-spi2-atk,
  at-spi2-core,
  cups,
  dbus,
  gtk3,
  pango,
  cairo,
  expat,
  glib,
  systemd,

  ### For virtiofsd
  libseccomp,
  libcap_ng,

  ### For keyring support
  libsecret,

  ### For Cowork QEMU
  qemu,
  OVMF,

  ### For extensions
  python3,
  nodejs,
  ### Force a specific password store backend (e.g. "gnome-libsecret" for non-GNOME DEs)
  passwordStore ? null,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "claude-desktop";
  version = "1.17377.0";
  strictDeps = true;
  __structuredAttrs = true;

  src =
    if stdenvNoCC.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://downloads.claude.ai/claude-desktop/apt/stable/pool/main/c/claude-desktop/claude-desktop_${finalAttrs.version}_amd64.deb";
        hash = "sha256-VjyN+O47lXyiNBFZgDhulgAH7Yz8jMBMd9WKjUP2wBg=";
      }
    else if stdenvNoCC.hostPlatform.system == "aarch64-linux" then
      fetchurl {
        url = "https://downloads.claude.ai/claude-desktop/apt/stable/pool/main/c/claude-desktop/claude-desktop_${finalAttrs.version}_arm64.deb";
        hash = "sha256-R1ms8ZtqyYH7rlzRwlqCjunG6Vz6nqTLjJzNfC/FOHE=";
      }
    else
      throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}";

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    ### Electron/Chromium
    nss
    nspr
    mesa
    alsa-lib
    libxkbcommon
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    at-spi2-atk
    at-spi2-core
    cups
    dbus
    gtk3
    pango
    cairo
    expat
    glib
    systemd

    ### Bundled virtiofsd
    libseccomp
    libcap_ng

    ### For keyring support
    libsecret

    ### For Cowork QEMU
    qemu
    OVMF

    ### For extensions
    python3
    nodejs
  ];

  unpackPhase = ''
    runHook preUnpack

    dpkg-deb --fsys-tarfile $src | tar --extract

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv usr/* $out

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/claude-desktop \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libsecret ]} \
      --prefix PATH : ${
        lib.makeBinPath [
          python3
          nodejs
          qemu
        ]
      } \
      ${lib.optionalString (passwordStore != null) ''
        --add-flags "--password-store=${passwordStore}" \
      ''}
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Desktop application for Claude.ai";
    homepage = "https://claude.ai/download";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ minegameYTB ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
