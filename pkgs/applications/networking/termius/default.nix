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
}:

stdenv.mkDerivation rec {
  pname = "termius";
  version = "7.17.1";

  src = fetchurl {
    # find the latest version with
    # curl -H 'X-Ubuntu-Series: 16' https://api.snapcraft.io/api/v1/snaps/details/termius-app | jq '.version'
    # and the url with
    # curl -H 'X-Ubuntu-Series: 16' https://api.snapcraft.io/api/v1/snaps/details/termius-app | jq '.download_url' -r
    url = "https://api.snapcraft.io/api/v1/snaps/download/WkTBXwoX81rBe3s3OTt3EiiLKBx2QhuS_81.snap";
    sha256 = "sha256-jNwWQTjUy8nJ8gHlbP9WgDlARWOhTQAA7KAcQNXKhNg=";
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

  buildInputs = atomEnv.packages;

  unpackPhase = ''
    runHook preUnpack
    unsquashfs "$src"
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    cd squashfs-root
    mkdir -p $out/opt/termius
    cp -r \
        icudtl.dat \
        libffmpeg.so \
        locales \
        resources \
        resources.pak \
        termius-app \
        v8_context_snapshot.bin \
        $out/opt/termius

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
