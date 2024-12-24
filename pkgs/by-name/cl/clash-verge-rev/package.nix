{
  lib,
  mihomo,
  callPackage,
  fetchFromGitHub,
  dbip-country-lite,
  stdenv,
  wrapGAppsHook3,
  v2ray-geoip,
  v2ray-domain-list-community,
  copyDesktopItems,
  makeDesktopItem,
  libsoup,
}:
let
  pname = "clash-verge-rev";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "clash-verge-rev";
    repo = "clash-verge-rev";
    rev = "refs/tags/v${version}";
    hash = "sha256-QLvJO1JFHPFOsVxNi6SCu2QuJQ9hCsO1+WKOjZL944w=";
  };

  src-service = fetchFromGitHub {
    owner = "clash-verge-rev";
    repo = "clash-verge-service";
    rev = "8b676086f2770e213cffea08ef31b54b886f8f11"; # no meaningful tags in this repo. The only way is updating manully every time.
    hash = "sha256-vF26Bp52y2kNHwwtBjy3Of75qJpTriqvul29KmudHww=";
  };

  service-cargo-hash = "sha256-pMOCifffUyBkcXC8inZFZeZVHeaOt0LAu2jZUGQ7QdM=";

  service = callPackage ./service.nix {
    inherit
      version
      src-service
      service-cargo-hash
      pname
      meta
      ;
  };

  webui = callPackage ./webui.nix {
    inherit
      version
      src
      pname
      meta
      npm-hash
      ;
  };

  npm-hash = "sha256-zsgZhLC+XUzlCUKKGAJV5MlSpWsoLmAgMwKkmAkAX9Q=";
  vendor-hash = "sha256-fk3OdJ1CKNHkeUjquJtJgM7PDyPpQ7tssDnFZHMbQHI=";

  unwrapped = callPackage ./unwrapped.nix {
    inherit
      pname
      version
      src
      vendor-hash
      webui
      meta
      libsoup
      ;
  };

  meta = {
    description = "Clash GUI based on tauri";
    homepage = "https://github.com/clash-verge-rev/clash-verge-rev";
    license = lib.licenses.gpl3Only;
    mainProgram = "clash-verge";
    maintainers = with lib.maintainers; [
      Guanran928
      bot-wxt1221
    ];
    platforms = lib.platforms.linux;
  };
in
stdenv.mkDerivation {
  inherit
    pname
    src
    version
    meta
    ;

  nativeBuildInputs = [
    wrapGAppsHook3
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "clash-verge";
      exec = "clash-verge";
      comment = "Clash Verge Rev";
      type = "Application";
      icon = "clash-verge";
      desktopName = "Clash Verge Rev";
      terminal = false;
      categories = [ "Network" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share,lib/clash-verge/resources}
    cp -r ${unwrapped}/share/* $out/share
    cp -r ${unwrapped}/bin/clash-verge $out/bin/clash-verge
    # This can't be symbol linked. It will find mihomo in its runtime path
    ln -s ${service}/bin/clash-verge-service $out/bin/clash-verge-service
    ln -s ${mihomo}/bin/mihomo $out/bin/verge-mihomo
    # people who want to use alpha build show override mihomo themselves. The alpha core entry was removed in clash-verge.
    ln -s ${v2ray-geoip}/share/v2ray/geoip.dat $out/lib/clash-verge/resources/geoip.dat
    ln -s ${v2ray-domain-list-community}/share/v2ray/geosite.dat $out/lib/clash-verge/resources/geosite.dat
    ln -s ${dbip-country-lite.mmdb} $out/lib/clash-verge/resources/Country.mmdb
    runHook postInstall
  '';
}
