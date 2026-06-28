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
  libsoup_3,
}:
let
  pname = "clash-verge-rev";
  # Please keep service version in sync
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "clash-verge-rev";
    repo = "clash-verge-rev";
    tag = "v${version}";
    hash = "sha256-2X2QlWo12qM7RT0wjf1Xlmh3We2wZR/kJnSxIxVst9Y=";
  };

  pnpm-hash = "sha256-JvY7olf1OOQ+j/z7hFEcmum24WlPggrur3K8cTEgc7g=";
  vendor-hash = "sha256-nF9d1OWpn3rf4EPhD4vqQbKEp/J5pc7J7XJDgAjd0DA=";

  service = callPackage ./service.nix {
    inherit
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
      libsoup_3
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
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook3
  ];

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
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
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    cp -R ${unwrapped}/Applications/Clash\ Verge.app $out/Applications/
    chmod -R u+w $out/Applications/Clash\ Verge.app

    ln -s ${mihomo}/bin/mihomo $out/Applications/Clash\ Verge.app/Contents/MacOS/verge-mihomo

    mkdir -p $out/Applications/Clash\ Verge.app/Contents/Resources/resources
    ln -s ${v2ray-geoip}/share/v2ray/geoip.dat $out/Applications/Clash\ Verge.app/Contents/Resources/resources/geoip.dat
    ln -s ${v2ray-domain-list-community}/share/v2ray/geosite.dat $out/Applications/Clash\ Verge.app/Contents/Resources/resources/geosite.dat
    ln -s ${dbip-country-lite.mmdb} $out/Applications/Clash\ Verge.app/Contents/Resources/resources/Country.mmdb

    ln -s "$out/Applications/Clash Verge.app/Contents/MacOS/clash-verge" "$out/bin/clash-verge"
  ''
  + ''
    runHook postInstall
  '';
  # For testing convenience
  passthru = { inherit unwrapped service; };
}
