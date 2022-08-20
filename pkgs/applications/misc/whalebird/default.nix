{ lib, stdenv, fetchurl, autoPatchelfHook, makeDesktopItem, copyDesktopItems, makeWrapper, electron
, nodePackages, alsa-lib, gtk3, libdbusmenu, libxshmfence, mesa, nss }:

stdenv.mkDerivation rec {
  pname = "whalebird";
  version = "4.6.0";

  src = let
    downloads = "https://github.com/h3poteto/whalebird-desktop/releases/download/${version}";
  in
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = downloads + "/Whalebird-${version}-linux-x64.tar.bz2";
        sha256 = "02f2f4b7184494926ef58523174acfa23738d5f27b4956d094836a485047c2f8";
      }
    else if stdenv.system == "aarch64-linux" then
      fetchurl {
        url = downloads + "/Whalebird-${version}-linux-arm64.tar.bz2";
        sha256 = "de0cdf7cbd6f0305100a2440e2559ddce0a5e4ad73a341874d6774e23dc76974";
      }
    else
      throw "Whalebird is not supported for ${stdenv.system}";

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    copyDesktopItems
    nodePackages.asar
  ];

  buildInputs = [ alsa-lib gtk3 libdbusmenu libxshmfence mesa nss ];

  desktopItems = [
    (makeDesktopItem {
      desktopName = "Whalebird";
      comment = meta.description;
      categories = [ "Network" ];
      exec = "whalebird";
      icon = "whalebird";
      name = "whalebird";
    })
  ];

  unpackPhase = ''
    mkdir -p opt
    tar -xf ${src} -C opt
    # remove the version/target suffix from the untar'd directory
    mv opt/Whalebird-* opt/Whalebird
  '';

  buildPhase = ''
    runHook preBuild

    # Necessary steps to find the tray icon
    asar extract opt/Whalebird/resources/app.asar "$TMP/work"
    substituteInPlace $TMP/work/dist/electron/main.js \
      --replace "Do,\"tray_icon.png\"" "\"$out/opt/Whalebird/resources/build/icons/tray_icon.png\""
    asar pack --unpack='{*.node,*.ftz,rect-overlay}' "$TMP/work" opt/Whalebird/resources/app.asar

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    mv opt $out

    # install icons
    for icon in $out/opt/Whalebird/resources/build/icons/*.png; do
      mkdir -p "$out/share/icons/hicolor/$(basename $icon .png)/apps"
      ln -s "$icon" "$out/share/icons/hicolor/$(basename $icon .png)/apps/whalebird.png"
    done

    makeWrapper ${electron}/bin/electron $out/bin/whalebird \
      --add-flags $out/opt/Whalebird/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland}}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Electron based Mastodon, Pleroma and Misskey client for Windows, Mac and Linux";
    homepage = "https://whalebird.social";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang colinsane ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
