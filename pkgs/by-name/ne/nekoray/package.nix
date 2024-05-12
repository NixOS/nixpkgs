{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
  cmake,
  ninja,
  protobuf,
  yaml-cpp,
  zxing-cpp,
  callPackage,
  makeDesktopItem,
  copyDesktopItems,

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
    Xray-core = fetchSource {
      name = "Xray-core";
      rev = "01208225ee7e508044cca8eb6776a117bcecd997";
      hash = "sha256-R66i9MITdE9JlhD4wV0EitKPxyahQqDNpunUxVTmupA=";
    };
    sing-box-extra = fetchSource {
      name = "sing-box-extra";
      rev = "d31d6da26a51a929349e0d75fd89dccbe20d1268";
      hash = "sha256-YlzMAff8VOZGyCP7ksjcmoBDHT5llTYwwXIrs+qO5P4=";
    };

    # revs found in https://github.com/MatsuriDayo/sing-box-extra/blob/<sing-box-extra.rev>/libs/get_source_env.sh
    sing-box = fetchSource {
      name = "sing-box";
      rev = "64f4eed2c667d9ff1e52a84233dee0e2ca32c17e";
      hash = "sha256-jIg/+fvTn46h6tE6YXtov+ZaBD/ywApTZbzHlT5v4lM=";
    };
    sing-quic = fetchSource {
      name = "sing-quic";
      rev = "e396733db4de15266f0cfdb43c392aca0759324a";
      hash = "sha256-un5NtZPRx1QAjwNhXkR9OVGldtfM1jQoNRUzt9oilUE=";
    };
    libneko = fetchSource {
      name = "libneko";
      rev = "5277a5bfc889ee7a89462695b0e678c1bd4909b1";
      hash = "sha256-6dlWDzI9ox4PQzEtJNgwA0pXmPC7fGrGId88Zl+1gpw=";
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
      install -Dm644 ${file} "$out/share/nekoray/${filename}"
    '') geodata
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nekoray";
  version = "3.26";

  src = fetchSource {
    name = "nekoray";
    rev = finalAttrs.version;
    hash = "sha256-fDm6fCI6XA4DHKCN3zm9B7Qbdh3LTHYGK8fPmeEnhjI=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    libsForQt5.wrapQtAppsHook
    cmake
    ninja
    copyDesktopItems
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qttools
    libsForQt5.qtx11extras
    protobuf
    yaml-cpp
    zxing-cpp
  ];

  # NKR_PACKAGE makes sure the app uses the user's config directory to store it's non-static content
  # it's essentially the same as always setting the -appdata flag when running the program
  cmakeFlags = [ (lib.cmakeBool "NKR_PACKAGE" true) ];

  installPhase = ''
    runHook preInstall

    install -Dm755 nekoray "$out/share/nekoray/nekoray"
    mkdir -p "$out/bin"
    ln -s "$out/share/nekoray/nekoray" "$out/bin"

    # nekoray looks for other files and cores in the same directory it's located at
    ln -s ${finalAttrs.passthru.nekoray-core}/bin/nekoray_core "$out/share/nekoray/nekoray_core"
    ln -s ${finalAttrs.passthru.nekobox-core}/bin/nekobox_core "$out/share/nekoray/nekobox_core"

    ${installGeodata}

    install -Dm644 "$src/res/public/nekoray.png" "$out/share/icons/hicolor/256x256/apps/nekoray.png"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "nekoray";
      desktopName = "nekoray";
      exec = "nekoray";
      icon = "nekoray";
      comment = finalAttrs.meta.description;
      terminal = false;
      categories = [
        "Network"
        "Application"
      ];
    })
  ];

  passthru = {
    nekobox-core = callPackage ./nekobox-core.nix {
      inherit (finalAttrs) src version;
      inherit extraSources;
    };
    nekoray-core = callPackage ./nekoray-core.nix {
      inherit (finalAttrs) src version;
      inherit extraSources;
    };
  };

  meta = {
    description = "Qt based cross-platform GUI proxy configuration manager";
    homepage = "https://github.com/MatsuriDayo/nekoray";
    license = lib.licenses.gpl3Plus;
    mainProgram = "nekoray";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux;
  };
})
