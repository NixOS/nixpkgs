{ autoPatchelfHook
, squashfsTools
, alsa-lib
, copyDesktopItems
, fetchurl
, makeDesktopItem
, makeWrapper
, stdenv
, lib
, libsecret
, mesa
, udev
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "termius";
  version = "8.1.2";

  src = fetchurl {
    # find the latest version with
    # curl -H 'X-Ubuntu-Series: 16' https://api.snapcraft.io/api/v1/snaps/details/termius-app | jq '.version'
    # and the url with
    # curl -H 'X-Ubuntu-Series: 16' https://api.snapcraft.io/api/v1/snaps/details/termius-app | jq '.download_url' -r
    # and the sha512 with
    # curl -H 'X-Ubuntu-Series: 16' https://api.snapcraft.io/api/v1/snaps/details/termius-app | jq '.download_sha512' -r
    url = "https://api.snapcraft.io/api/v1/snaps/download/WkTBXwoX81rBe3s3OTt3EiiLKBx2QhuS_167.snap";
    hash = "sha512-M/cyLfSnoCFJcdGXlA5/kH/MuyRpYcfBoyp6y6KSsTyh8Goq6niGZAQcCdIjNX8KVUvmcTWISsx8so4W5BrkCw==";
  };

  desktopItems = [
    (makeDesktopItem {
      categories = [ "Network" ];
      comment = "The SSH client that works on Desktop and Mobile";
      desktopName = "Termius";
      exec = "termius-app";
      genericName = "Cross-platform SSH client";
      icon = "termius-app";
      name = "termius-app";
    })
  ];

  dontBuild = true;
  dontConfigure = true;
  dontPatchELF = true;
  dontWrapGApps = true;

  # TODO: migrate off autoPatchelfHook and use nixpkgs' electron
  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    squashfsTools
    makeWrapper
    wrapGAppsHook
  ];

  buildInputs = [
    alsa-lib
    libsecret
    mesa
  ];

  unpackPhase = ''
    runHook preUnpack
    unsquashfs "$src"
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    cd squashfs-root
    mkdir -p $out/opt/termius
    cp -r ./ $out/opt/termius

    mkdir -p "$out/share/pixmaps/termius-app.png"
    cp meta/gui/icon.png $out/share/pixmaps/termius-app.png

    runHook postInstall
  '';

  runtimeDependencies = [ (lib.getLib udev) ];

  postFixup = ''
    makeWrapper $out/opt/termius/termius-app $out/bin/termius-app \
      "''${gappsWrapperArgs[@]}"
  '';

  meta = with lib; {
    description = "A cross-platform SSH client with cloud data sync and more";
    homepage = "https://termius.com/";
    downloadPage = "https://termius.com/linux/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ Br1ght0ne th0rgal ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "termius-app";
  };
}
