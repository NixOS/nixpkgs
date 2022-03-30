{ atomEnv
, autoPatchelfHook
, squashfsTools
, fetchurl
, makeDesktopItem
, makeWrapper
, stdenv
, lib
, udev
, wrapGAppsHook
, libxshmfence
}:

stdenv.mkDerivation rec {
  pname = "termius";
  version = "7.37.0";

  src = fetchurl {
    # find the latest version with
    # curl -H 'X-Ubuntu-Series: 16' https://api.snapcraft.io/api/v1/snaps/details/termius-app | jq '.version'
    # and the url with
    # curl -H 'X-Ubuntu-Series: 16' https://api.snapcraft.io/api/v1/snaps/details/termius-app | jq '.download_url' -r
    # and the sha512 with
    # curl -H 'X-Ubuntu-Series: 16' https://api.snapcraft.io/api/v1/snaps/details/termius-app | jq '.download_sha512' -r
    url = "https://api.snapcraft.io/api/v1/snaps/download/WkTBXwoX81rBe3s3OTt3EiiLKBx2QhuS_108.snap";
    sha512 = "05c4a0baeee8c1ff9547017288d099a9ef7b3049647ef0318ca4b1112df26f9f3a844bbae5f9ada59adaf07838987e2a685aee21ea494945202009236fe5f6bc";
  };

  desktopItem = makeDesktopItem {
    categories = [ "Network" ];
    comment = "The SSH client that works on Desktop and Mobile";
    desktopName = "Termius";
    exec = "termius-app";
    genericName = "Cross-platform SSH client";
    icon = "termius-app";
    name = "termius-app";
  };

  dontBuild = true;
  dontConfigure = true;
  dontPatchELF = true;
  dontWrapGApps = true;

  nativeBuildInputs = [ autoPatchelfHook squashfsTools makeWrapper wrapGAppsHook ];

  buildInputs = atomEnv.packages ++ [ libxshmfence ];

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

    mkdir -p "$out/share/applications" "$out/share/pixmaps/termius-app.png"
    cp "${desktopItem}/share/applications/"* "$out/share/applications"
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
    license = licenses.unfree;
    maintainers = with maintainers; [ Br1ght0ne th0rgal ];
    platforms = [ "x86_64-linux" ];
  };
}
