{
  stdenvNoCC,
  lib,
  fetchurl,
  autoPatchelfHook,
  buildPackages,
  gnome-keyring,
  libsecret,
  git,
  curl,
  nss,
  nspr,
  xorg,
  libdrm,
  alsa-lib,
  cups,
  libgbm,
  systemdLibs,
  openssl,
  libglvnd,
}:

let
  rcversion = "1";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "github-desktop";
  version = "3.4.13";

  src =
    let
      urls = {
        "x86_64-linux" = {
          url = "https://github.com/shiftkey/desktop/releases/download/release-${finalAttrs.version}-linux${rcversion}/GitHubDesktop-linux-amd64-${finalAttrs.version}-linux${rcversion}.deb";
          hash = "sha256-i1V3dhx5AMrCiWtfvB2I9a6ki2zncUNyYr4qZqs42Yc=";
        };
        "aarch64-linux" = {
          url = "https://github.com/shiftkey/desktop/releases/download/release-${finalAttrs.version}-linux${rcversion}/GitHubDesktop-linux-arm64-${finalAttrs.version}-linux${rcversion}.deb";
          hash = "sha256-SN4qtEI4q/AAgfUaBiM5eWyCK5Kr77CrTHsIAmvEceU=";
        };
      };
    in
    fetchurl
      urls."${stdenvNoCC.hostPlatform.system}"
        or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");

  nativeBuildInputs = [
    autoPatchelfHook
    # override doesn't preserve splicing https://github.com/NixOS/nixpkgs/issues/132651
    # Has to use `makeShellWrapper` from `buildPackages` even though `makeShellWrapper` from the inputs is spliced because `propagatedBuildInputs` would pick the wrong one because of a different offset.
    (buildPackages.wrapGAppsHook3.override { makeWrapper = buildPackages.makeShellWrapper; })
  ];

  buildInputs = [
    gnome-keyring
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
    libgbm
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
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-wayland-ime=true}}"
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libglvnd ]}
    )
  '';

  runtimeDependencies = [
    systemdLibs
  ];

  meta = {
    description = "GUI for managing Git and GitHub";
    homepage = "https://desktop.github.com/";
    license = lib.licenses.mit;
    mainProgram = "github-desktop";
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
