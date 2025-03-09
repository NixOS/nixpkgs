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
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "clash-verge-rev";
    repo = "clash-verge-rev";
    tag = "v${version}";
    hash = "sha256-rsl3hBywToemthNrG80Mv+JagA4g4S7HukOaRpMKJi8=";
  };

  src-service = fetchFromGitHub {
    owner = "clash-verge-rev";
    repo = "clash-verge-service";
    rev = "bfd7d597b13d49cf49b64676c2719f1ed9599d22"; # no meaningful tags in this repo. The only way is updating manully every time.
    hash = "sha256-LdM0VIVsDPGnHEGwbRFh4/ACTdpVyDnu6dYLLvVbwpc=";
  };

  service-cargo-hash = "sha256-mJEk4OAEcuTk5NCzPcWwSlvysqR/9s8p9OGiXWBZvdg=";
  npm-hash = "sha256-1OT9Iv9AF4svaOnWNQfOUdo8EUkG0+PU+y8nprc6YjU=";
  vendor-hash = "sha256-myvFXaS+QdBRHPpcLEmhg1wgheWb4uXv+QXQf5HA51M=";

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
    longDescription = ''
      Clash GUI based on tauri
      Setting NixOS option `programs.clash-verge.enable = true` is recommended.
    '';
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

    mkdir -p $out/{bin,share,lib/Clash\ Verge/resources}
    cp -r ${unwrapped}/share/* $out/share
    cp -r ${unwrapped}/bin/clash-verge $out/bin/clash-verge
    # This can't be symbol linked. It will find mihomo in its runtime path
    ln -s ${service}/bin/clash-verge-service $out/bin/clash-verge-service
    ln -s ${mihomo}/bin/mihomo $out/bin/verge-mihomo
    # people who want to use alpha build show override mihomo themselves. The alpha core entry was removed in clash-verge.
    ln -s ${v2ray-geoip}/share/v2ray/geoip.dat $out/lib/Clash\ Verge/resources/geoip.dat
    ln -s ${v2ray-domain-list-community}/share/v2ray/geosite.dat $out/lib/Clash\ Verge/resources/geosite.dat
    ln -s ${dbip-country-lite.mmdb} $out/lib/Clash\ Verge/resources/Country.mmdb
    runHook postInstall
  '';
}
