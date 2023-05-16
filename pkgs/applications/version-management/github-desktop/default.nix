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

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "github-desktop";
  version = "3.2.5";

  src = fetchurl {
    url = "https://github.com/shiftkey/desktop/releases/download/release-${finalAttrs.version}-linux1/GitHubDesktop-linux-${finalAttrs.version}-linux1.deb";
    hash = "sha256-p+qr9/aEQcfkKArC3oTyIijHkaNzLum3xXeSnNexgbU=";
=======
stdenv.mkDerivation rec {
  pname = "github-desktop";
  version = "3.2.1";

  src = fetchurl {
    url = "https://github.com/shiftkey/desktop/releases/download/release-${version}-linux1/GitHubDesktop-linux-${version}-linux1.deb";
    hash = "sha256-OdvebRvOTyadgNjzrv6CGDPkljfpo4RVvVAc+X9hjSo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    mkdir -p $TMP/${finalAttrs.pname} $out/{opt,bin}
    cp $src $TMP/${finalAttrs.pname}.deb
    ar vx ${finalAttrs.pname}.deb
    tar --no-overwrite-dir -xvf data.tar.xz -C $TMP/${finalAttrs.pname}/
  '';

  installPhase = ''
    cp -R $TMP/${finalAttrs.pname}/usr/share $out/
    cp -R $TMP/${finalAttrs.pname}/usr/lib/${finalAttrs.pname}/* $out/opt/
    ln -sf $out/opt/${finalAttrs.pname} $out/bin/${finalAttrs.pname}
=======
    mkdir -p $TMP/${pname} $out/{opt,bin}
    cp $src $TMP/${pname}.deb
    ar vx ${pname}.deb
    tar --no-overwrite-dir -xvf data.tar.xz -C $TMP/${pname}/
  '';

  installPhase = ''
    cp -R $TMP/${pname}/usr/share $out/
    cp -R $TMP/${pname}/usr/lib/${pname}/* $out/opt/
    ln -sf $out/opt/${pname} $out/bin/${pname}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland}}"
    )
  '';

  runtimeDependencies = [
    (lib.getLib systemd)
  ];

<<<<<<< HEAD
  meta = {
    description = "GUI for managing Git and GitHub.";
    homepage = "https://desktop.github.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dan4ik605743 ];
    platforms = lib.platforms.linux;
  };
})
=======
  meta = with lib; {
    description = "GUI for managing Git and GitHub.";
    homepage = "https://desktop.github.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
