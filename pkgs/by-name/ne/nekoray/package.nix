{
  lib,
  stdenv,
  fetchFromGitHub,
  qt6,

  cmake,
  ninja,

  protobuf,
  yaml-cpp,
  zxing-cpp,

  callPackage,
  copyDesktopItems,
  makeDesktopItem,

  v2ray-geoip,
  v2ray-domain-list-community,
  sing-geoip,
  sing-geosite,
}:

let
  fetchSource =
    args:
    fetchFromGitHub (
      args
      // {
        owner = "MatsuriDayo";
        repo = args.name;
      }
    );

  extraSources = {
    # revs found in https://github.com/MatsuriDayo/nekoray/blob/<version>/libs/get_source_env.sh
    libneko = fetchSource {
      name = "libneko";
      rev = "1c47a3af71990a7b2192e03292b4d246c308ef0b";
      hash = "sha256-9ftRh8K4z7m265dbEwWSBeNiwznnNl/FolVv4rZ4C8E=";
    };
    sing-box = fetchSource {
      name = "sing-box";
      rev = "06557f6cef23160668122a17a818b378b5a216b5";
      hash = "sha256-WyDYOY9udumTlf9ZNOYWKsPmJz3W/wp5kZYJkmvqokk=";
    };
    sing-quic = fetchSource {
      name = "sing-quic";
      rev = "b49ce60d9b3622d5238fee96bfd3c5f6e3915b42";
      hash = "sha256-U6v7ts2b9Kzp+U/hOR7b8JM42diOW2PV6lA9EDFoZRo=";
    };
  };

  geodata = {
    "geoip.dat" = "${v2ray-geoip}/share/v2ray/geoip.dat";
    "geosite.dat" = "${v2ray-domain-list-community}/share/v2ray/geosite.dat";
    "geoip.db" = "${sing-geoip}/share/sing-box/geoip.db";
    "geosite.db" = "${sing-geosite}/share/sing-box/geosite.db";
  };

  installGeodata = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (filename: file: ''
      install -Dm644 ${file} "$out/share/nekobox/${filename}"
    '') geodata
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nekoray";
  version = "4.0.1";

  src = fetchSource {
    name = "nekoray";
    rev = finalAttrs.version;
    hash = "sha256-AaL/mROOciU42A6VDhsi6o0wUIReu0OWibEjKveHym8=";
    fetchSubmodules = true;
  };

  patches = [ ./use-appdata.patch ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    ninja
    qt6.qtsvg
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    protobuf
    qt6.qtbase
    qt6.qtsvg
    yaml-cpp
    zxing-cpp
  ];

  cmakeFlags = [ "-DQT_VERSION_MAJOR=6" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 nekobox "$out/share/nekobox/nekobox"
    mkdir -p "$out/bin"
    ln -s "$out/share/nekobox/nekobox" "$out/bin"

    # nekoray looks for other files and cores in the same directory it's located at
    ln -s ${finalAttrs.passthru.nekobox-core}/bin/nekobox_core "$out/share/nekobox/nekobox_core"

    ${installGeodata}

    install -Dm644 "$src/res/public/nekobox.png" "$out/share/icons/hicolor/256x256/apps/nekobox.png"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "nekoray";
      desktopName = "NekoRay";
      exec = "nekobox";
      icon = "nekobox";
      comment = finalAttrs.meta.description;
      terminal = false;
      categories = [ "Network" ];
    })
  ];

  passthru = {
    nekobox-core = callPackage ./nekobox-core.nix {
      inherit (finalAttrs) src version;
      inherit extraSources;
    };
  };

  meta = {
    description = "Qt based cross-platform GUI proxy configuration manager";
    homepage = "https://github.com/MatsuriDayo/nekoray";
    license = lib.licenses.gpl3Plus;
    mainProgram = "nekobox";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux;
  };
})
