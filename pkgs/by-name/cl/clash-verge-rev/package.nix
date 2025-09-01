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
  libsoup,
}:
let
  pname = "clash-verge-rev";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "clash-verge-rev";
    repo = "clash-verge-rev";
    tag = "v${version}";
    hash = "sha256-mTtHgH+Qf9OaQz7I5IT8SUpXOZVObwEGdKRKq107rLU=";
  };

  src-service = fetchFromGitHub {
    owner = "clash-verge-rev";
    repo = "clash-verge-service";
    rev = "cccf77a22ac78fe2188fd3bf519d368a2549b941"; # no meaningful tags in this repo. The only way is updating manully every time.
    hash = "sha256-ADtY3h69JiRw43H+V6mzyDr/XsnAVwXXRZGBSRNA4TY=";
  };

  service-cargo-hash = "sha256-a6jp3v/AdcWvBCzEfdtfbHUdqh3a1gNN9D8hRdU1RTc=";
  pnpm-hash = "sha256-WrJ5iWuPoXe220ZPAbo4Z9Zlk2B9Cob0KOL6Q+xSVys=";
  vendor-hash = "sha256-aOXBk3RZfelqdeKwP992rjBJ6Ps2GdEGBqzMBudCqKw=";

  service = callPackage ./service.nix {
    inherit
      version
      src-service
      service-cargo-hash
      pname
      meta
      ;
  };

  unwrapped = callPackage ./unwrapped.nix {
    inherit
      pname
      version
      src
      pnpm-hash
      vendor-hash
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
      hhr2020
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
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share,lib/Clash\ Verge/resources}
    cp -r ${unwrapped}/share/* $out/share
    cp -r ${unwrapped}/bin/clash-verge $out/bin/clash-verge
    # This can't be symbol linked. It will find mihomo in its runtime path
    cp ${service}/bin/clash-verge-service $out/bin/clash-verge-service
    ln -s ${mihomo}/bin/mihomo $out/bin/verge-mihomo
    # people who want to use alpha build show override mihomo themselves. The alpha core entry was removed in clash-verge.
    ln -s ${v2ray-geoip}/share/v2ray/geoip.dat $out/lib/Clash\ Verge/resources/geoip.dat
    ln -s ${v2ray-domain-list-community}/share/v2ray/geosite.dat $out/lib/Clash\ Verge/resources/geosite.dat
    ln -s ${dbip-country-lite.mmdb} $out/lib/Clash\ Verge/resources/Country.mmdb

    runHook postInstall
  '';
}
