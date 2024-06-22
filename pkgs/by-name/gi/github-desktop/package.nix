{ stdenvNoCC
, lib
, fetchurl
, autoPatchelfHook
, wrapGAppsHook3
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
, libglvnd
}:

let
  rcversion = "2";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "github-desktop";
  version = "3.3.12";

  src =
    let
      urls = {
        "x86_64-linux" = {
          url = "https://github.com/shiftkey/desktop/releases/download/release-${finalAttrs.version}-linux${rcversion}/GitHubDesktop-linux-amd64-${finalAttrs.version}-linux${rcversion}.deb";
          hash = "sha256-iflKD7NPuZvhxviNW8xmtCOYgdRz1rXiG42ycWCjXiY=";
        };
        "aarch64-linux" = {
          url = "https://github.com/shiftkey/desktop/releases/download/release-${finalAttrs.version}-linux${rcversion}/GitHubDesktop-linux-arm64-${finalAttrs.version}-linux${rcversion}.deb";
          hash = "sha256-C9eCvuf/TwXQiYjZ88xSiyaqi8+cppmrLiSYTyQCkmg=";
        };
      };
    in
    fetchurl urls."${stdenvNoCC.hostPlatform.system}" or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");

  nativeBuildInputs = [
    autoPatchelfHook
    (wrapGAppsHook3.override { inherit makeWrapper; })
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
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libglvnd ]}
    )
  '';

  runtimeDependencies = [
    (lib.getLib systemd)
  ];

  meta = {
    description = "GUI for managing Git and GitHub";
    homepage = "https://desktop.github.com/";
    license = lib.licenses.mit;
    mainProgram = "github-desktop";
    maintainers = with lib.maintainers; [ dan4ik605743 ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
