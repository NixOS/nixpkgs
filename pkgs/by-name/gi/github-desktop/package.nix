{ stdenvNoCC
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

let
  rcversion = "1";
  arch = "amd64";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "github-desktop";
  version = "3.3.10";

  src = fetchurl {
    url = "https://github.com/shiftkey/desktop/releases/download/release-${finalAttrs.version}-linux${rcversion}/GitHubDesktop-linux-${arch}-${finalAttrs.version}-linux${rcversion}.deb";
    hash = "sha256-zzq6p/DAQmgSw4KAUYqtrQKkIPksLzkUQjGzwO26WgQ=";
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
    runHook preUnpack
    mkdir -p $TMP/github-desktop $out/{opt,bin}
    cp $src $TMP/github-desktop.deb
    ar vx github-desktop.deb
    tar --no-overwrite-dir -xvf data.tar.xz -C $TMP/github-desktop/
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    cp -R $TMP/github-desktop/usr/share $out/
    cp -R $TMP/github-desktop/usr/lib/github-desktop/* $out/opt/
    ln -sf $out/opt/github-desktop $out/bin/github-desktop
    runHook postInstall
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
    license = lib.licenses.mit;
    mainProgram = "github-desktop";
    maintainers = with lib.maintainers; [ dan4ik605743 ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
