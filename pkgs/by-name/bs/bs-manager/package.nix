{
  alsa-lib,
  autoPatchelfHook,
  atk,
  bash,
  cairo,
  cups,
  dbus,
  dpkg,
  fetchurl,
  ffmpeg,
  glib,
  glibc,
  gtk3,
  lib,
  libappindicator-gtk3,
  libdrm,
  libxkbfile,
  libxkbcommon,
  makeWrapper,
  mesa,
  nss,
  nspr,
  nix-update-script,
  pango,
  pkgs,
  python3,
  opencomposite,
  stdenv,
  systemd,
  vulkan-loader,
  xorg,
  depotdownloader,
  openssl,
  wrapGAppsHook3,
}:
let
  version = "1.5.0-alpha.8";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://github.com/Zagrios/bs-manager/releases/download/v1.5.0-alpha.8/bs-manager_1.5.0-alpha.8_amd64.deb";
        hash = "sha256-xQ3ha6J1wqzZj25QwlMX2lwDDNXlzVvpUqXkaH9kCbE=";
      }
    else
      throw "BSManager is not available for your platform";

  rpath = lib.makeLibraryPath [
    alsa-lib
    atk
    cairo
    cups
    dbus
    ffmpeg
    glib
    glibc
    gtk3
    libappindicator-gtk3
    libdrm
    libxkbcommon
    libxkbfile
    mesa
    nspr
    nss
    pango
    stdenv.cc.cc
    vulkan-loader
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libXtst
    xorg.libxcb
    xorg.libxkbfile
  ];
in
stdenv.mkDerivation {
  pname = "bs-manager";
  inherit version;

  system = "x86_64-linux";

  inherit src;

  runtimeDependencies = [
    bash
    opencomposite
    python3
    systemd
    depotdownloader
    openssl
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    ffmpeg
    mesa
    nspr
    nss
    makeWrapper
    openssl
    wrapGAppsHook3
  ];

  buildInputs = [
    ffmpeg
    openssl
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    dpkg -x $src $out
    cp -av $out/usr/* $out
    rm -rf $out/usr

    # Otherwise it looks "suspicious"
    chmod -R g-w $out

    export FONTCONFIG_FILE=${pkgs.makeFontsConf { fontDirectories = [ ]; }}

    patchelf --set-rpath $out/opt/BSManager $out/opt/BSManager/bs-manager

    for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* \)); do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
      patchelf --set-rpath ${rpath} "$file" || true
    done

    mkdir -p $out/bin
    ln -s $out/opt/BSManager/bs-manager $out/bin/bs-manager

    runHook postInstall
  '';

  postInstall = ''
    # Create a wrapper script to use the correct LD_LIBRARY_PATH
    mv $out/opt/BSManager/resources/assets/scripts/DepotDownloader $out/opt/BSManager/resources/assets/scripts/DepotDownload
    makeWrapper \
      "$out/opt/BSManager/resources/assets/scripts/DepotDownload" \
      "$out/opt/BSManager/resources/assets/scripts/DepotDownloader" \
      --set LD_LIBRARY_PATH "${openssl.out}/lib:$LD_LIBRARY_PATH"

    chmod +x $out/opt/BSManager/resources/assets/scripts/DepotDownloader

    # Update the desktop file
    substituteInPlace $out/share/applications/bs-manager.desktop \
      --replace-fail /opt/BSManager/bs-manager bs-manager
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/Zagrios/bs-manager/blob/master/CHANGELOG.md";
    description = "BSManager: Your Beat Saber Assistant";
    homepage = "https://github.com/Zagrios/bs-manager";
    license = lib.licenses.gpl3Only;
    mainProgram = "bs-manager";
    maintainers = with lib.maintainers; [ mistyttm ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
