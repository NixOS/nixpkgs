{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, wrapGAppsHook
, makeWrapper
, gnome
, libsecret
, git
, curl
, nss
, nspr
, xorg
, libdrm
, alsa-lib
, cups
, mesa
, systemd
, openssl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "github-desktop";
  version = "3.3.6";
  rcversion = "3";
  arch = "amd64";

  src = fetchurl {
    url = "https://github.com/shiftkey/desktop/releases/download/release-${finalAttrs.version}-linux${finalAttrs.rcversion}/GitHubDesktop-linux-${finalAttrs.arch}-${finalAttrs.version}-linux${finalAttrs.rcversion}.deb";
    hash = "sha256-900JhfHN78CuAXptPX2ToTvT9E+g+xRXqmlm34J9l6k=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    (wrapGAppsHook.override { inherit makeWrapper; })
  ];

  buildInputs = [
    gnome.gnome-keyring
    xorg.libXdamage
    xorg.libX11
    libsecret
    git
    curl
    nss
    nspr
    libdrm
    alsa-lib
    cups
    mesa
    openssl
  ];

  unpackPhase = ''
    mkdir -p $TMP/${finalAttrs.pname} $out/{opt,bin}
    cp $src $TMP/${finalAttrs.pname}.deb
    ar vx ${finalAttrs.pname}.deb
    tar --no-overwrite-dir -xvf data.tar.xz -C $TMP/${finalAttrs.pname}/
  '';

  installPhase = ''
    cp -R $TMP/${finalAttrs.pname}/usr/share $out/
    cp -R $TMP/${finalAttrs.pname}/usr/lib/${finalAttrs.pname}/* $out/opt/
    ln -sf $out/opt/${finalAttrs.pname} $out/bin/${finalAttrs.pname}
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland}}"
    )
  '';

  runtimeDependencies = [
    (lib.getLib systemd)
  ];

  meta = {
    description = "GUI for managing Git and GitHub.";
    homepage = "https://desktop.github.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dan4ik605743 ];
    platforms = lib.platforms.linux;
    mainProgram = "github-desktop";
  };
})
