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
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "clash-verge-rev";
    repo = "clash-verge-rev";
    tag = "v${version}";
    hash = "sha256-MJD1FWh/43pOffdWznCVPyGVXcIyqhXzmoEmyM8Tspg=";
  };

  src-service = fetchFromGitHub {
    owner = "clash-verge-rev";
    repo = "clash-verge-service";
    rev = "ffcccc6095e052534980230f9e0ca97db2675062"; # no meaningful tags in this repo. The only way is updating manully every time.
    hash = "sha256-AbUflPcuSuUigRQB0i52mfVu5sIep1vMZGVMZyznwXY=";
  };

  service-cargo-hash = "sha256-lMOQznPlkHIMSm5nOLuGP9qJXt3CXnd+q8nCu+Xbbt8=";
  pnpm-hash = "sha256-v9+1NjXo/1ogmep+4IP+9qoUR1GJz87VGeOoMzQ1Rfw=";
  vendor-hash = "sha256-y3XVHi00mnuVFxSd02YBgfWuXYRVIs+e0tITXNOFRsA=";

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
