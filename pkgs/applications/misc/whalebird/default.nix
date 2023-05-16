<<<<<<< HEAD
{ lib, stdenv, fetchurl
, autoPatchelfHook, makeDesktopItem, copyDesktopItems, makeWrapper, gnugrep, asar
, electron, python3, alsa-lib, gtk3, libdbusmenu, libxshmfence, mesa, nss
}:

stdenv.mkDerivation rec {
  pname = "whalebird";
  version = "5.0.7";

  src = let
    downloads = "https://github.com/h3poteto/whalebird-desktop/releases/download/v${version}";
=======
{ lib, stdenv, fetchurl, autoPatchelfHook, makeDesktopItem, copyDesktopItems, makeWrapper, electron
, nodePackages, alsa-lib, gtk3, libdbusmenu, libxshmfence, mesa, nss }:

stdenv.mkDerivation rec {
  pname = "whalebird";
  version = "4.7.4";

  src = let
    downloads = "https://github.com/h3poteto/whalebird-desktop/releases/download/${version}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  in
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = downloads + "/Whalebird-${version}-linux-x64.tar.bz2";
<<<<<<< HEAD
        hash = "sha256-eufP038REwF2VwAxxI8R0S3fE8oJ+SX/CES5ozuut2w=";
=======
        sha256 = "sha256-jRtlnKlrh6If9wy3FqVBtctQO3rZJRwceUWAPmieT4A=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      }
    else if stdenv.system == "aarch64-linux" then
      fetchurl {
        url = downloads + "/Whalebird-${version}-linux-arm64.tar.bz2";
<<<<<<< HEAD
        hash = "sha256-U0xVTUUm6wsRxYc1w4vfNtVE6o8dNzXTSi+IX4mgDEE=";
=======
        sha256 = "sha256-gWCBH2zfhJdJ3XUAxvZ0+gBHye5uYCUgX1BDEoaruxY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      }
    else
      throw "Whalebird is not supported for ${stdenv.system}";

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    copyDesktopItems
<<<<<<< HEAD
    gnugrep
    asar
=======
    nodePackages.asar
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    # For aarch64-linux, we need to overwrite this symlink first as it points to
    # /usr/bin/python3
    if [ "${stdenv.system}" = "aarch64-linux" ]
    then ln -sf ${python3}/bin/python3 \
      opt/Whalebird/resources/app.asar.unpacked/node_modules/better-sqlite3/build/node_gyp_bins/python3
    fi
    asar extract opt/Whalebird/resources/app.asar "$TMP/work"
    substituteInPlace "$TMP/work/dist/electron/main.js" \
      --replace "$(grep -oE '.{2},"tray_icon.png"' "$TMP/work/dist/electron/main.js")" \
        "\"$out/opt/Whalebird/resources/build/icons/tray_icon.png\""
=======
    asar extract opt/Whalebird/resources/app.asar "$TMP/work"
    substituteInPlace $TMP/work/dist/electron/main.js \
      --replace "qt,\"tray_icon.png\"" "\"$out/opt/Whalebird/resources/build/icons/tray_icon.png\""
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Electron based Mastodon, Pleroma and Misskey client for Windows, Mac and Linux";
    homepage = "https://whalebird.social";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
<<<<<<< HEAD
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang colinsane weathercold ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang colinsane ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
