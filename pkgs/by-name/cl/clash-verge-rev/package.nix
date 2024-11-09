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
}:
let
  pname = "clash-verge-rev";
  version = "1.7.7";

  src = fetchFromGitHub {
    owner = "clash-verge-rev";
    repo = "clash-verge-rev";
    rev = "v${version}";
    hash = "sha256-5sd0CkUCV52wrBPo0IRIa1uqf2QNkjXuZhE33cZW3SY=";
  };

  src-service = fetchFromGitHub {
    owner = "clash-verge-rev";
    repo = "clash-verge-service";
    rev = "e74e419f004275cbf35a427337d3f8c771408f07"; # no meaningful tags in this repo. The only way is updating manully every time.
    hash = "sha256-HyRTOqPj4SnV9gktqRegxOYz9c8mQHOX+IrdZlHhYpo=";
  };

  meta-unwrapped = {
    description = "Clash GUI based on tauri";
    homepage = "https://github.com/clash-verge-rev/clash-verge-rev";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      Guanran928
      bot-wxt1221
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };

  service-cargo-hash = "sha256-NBeHR6JvdCp06Ug/UEtLY2tu3iCmlsCU0x8umRbJXLU=";

  service = callPackage ./service.nix {
    inherit
      version
      src-service
      service-cargo-hash
      pname
      ;
    meta = meta-unwrapped;
  };

  webui = callPackage ./webui.nix {
    inherit
      version
      src
      pname
      ;
    meta = meta-unwrapped;

  };

  sysproxy-hash = "sha256-TEC51s/viqXUoEH9rJev8LdC2uHqefInNcarxeogePk=";

  unwrapped = callPackage ./unwrapped.nix {
    inherit
      pname
      version
      src
      sysproxy-hash
      webui
      ;
    meta = meta-unwrapped;
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
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
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
