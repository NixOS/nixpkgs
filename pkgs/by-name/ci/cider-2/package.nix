{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  gsettings-desktop-schemas,
  dconf,

  # Required dependencies for autoPatchelfHook
  alsa-lib,
  gtk3,
  libgbm,
  libGL,
  nspr,
  nss,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cider-2";
  version = "4.0.9.1";

  src = fetchurl {
    url = "https://repo.cider.sh/apt/pool/main/cider-v${finalAttrs.version}-linux-x64.deb";
    hash = "sha256-MsA6lK3PsyOEx938FgJFx8l9oqwoM3FzIK5goF73lTs=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    gtk3
    libgbm
    nspr
    nss
  ];
  # appendRunpaths is applied to every ELF, including shared libraries.
  # runtimeDependencies wouldn't work here because autoPatchelfHook rewrites
  # the RPATH of dynamic executables only, not of shared libraries.
  appendRunpaths = lib.makeLibraryPath [
    libGL # libEGL.so.1 is dlopen'd by ANGLE from libGLESv2.so
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb --fsys-tarfile $src | tar --extract
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share,lib}
    cp -r usr/share/* $out/share/
    cp -r usr/lib/* $out/lib/

    chmod +x $out/lib/cider/Cider

    # The prefixes that follow --add-flags are typically injected via wrapGAppsHook3.
    # We append them manually instead to avoid a double-wrapping.
    makeWrapper $out/lib/cider/Cider $out/bin/cider-2 \
      --add-flags "\$\{NIXOS_OZONE_WL:+\$\{WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true\}\}" \
      --add-flags "--no-sandbox --disable-gpu-sandbox" \
      --prefix XDG_DATA_DIRS : "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}" \
      --prefix GIO_EXTRA_MODULES : "${dconf.lib}/lib/gio/modules" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"

    runHook postInstall
  '';

  postFixup = ''
    mv $out/share/applications/cider.desktop $out/share/applications/cider-2.desktop
    substituteInPlace $out/share/applications/cider-2.desktop \
      --replace-fail Exec=cider Exec=cider-2 \
      --replace-fail Icon=cider Icon=cider-2

    install -Dm444 $out/share/pixmaps/cider.png \
      $out/share/icons/hicolor/256x256/apps/cider-2.png

    rm -r $out/share/{pixmaps,lintian}
    rm $out/lib/cider/resources/Cider{,.flatpak}.desktop
    rm $out/lib/cider/resources/public/icon{.icns,-osx-previous.icns,.ico}
  '';

  passthru.updateScript = ./updater.sh;

  meta = {
    description = "Powerful music player that allows you listen to your favorite tracks with style";
    homepage = "https://cider.sh";
    license = lib.licenses.unfree;
    mainProgram = "cider-2";
    maintainers = with lib.maintainers; [
      amadejkastelic
      antoineco
      l0r3v
    ];
    platforms = [ "x86_64-linux" ];
  };
})
