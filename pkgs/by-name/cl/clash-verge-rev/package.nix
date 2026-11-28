{
  lib,
  mihomo,
  callPackage,
  fetchFromGitHub,
  dbip-asn-lite,
  dbip-country-lite,
  stdenv,
  wrapGAppsHook3,
  v2ray-geoip,
  v2ray-rules-dat,
  libsoup_3,
}:
let
  pname = "clash-verge-rev";
  # Please keep service version in sync
  version = "2.5.10";

  src = fetchFromGitHub {
    owner = "clash-verge-rev";
    repo = "clash-verge-rev";
    tag = "v${version}";
    hash = "sha256-H9thwAL/o2njnXai+KwbuuDV9ngInTphwgConpA5we8=";
  };

  cargoPatches = [
    # TODO: remove once upstream updates webpki
    #  rustls-webpki 0.103.15 -> 0.103.16
    #  webpki-root 1.0.9 -> 1.0.10
    ./update-webpki.patch
  ];

  pnpm-hash = "sha256-rvTs8Qsohg+SGrG7DLjDHxQ0+OSuTjaPNWXAiMIpPc4=";
  vendor-hash = "sha256-gv8sp5lkZyRBc/NdiGDfQsyTk8zz4+j1f/YN3Vspsxs=";

  service = callPackage ./service.nix {
    inherit
      meta
      mihomo
      ;
  };

  unwrapped = callPackage ./unwrapped.nix {
    inherit
      pname
      version
      src
      cargoPatches
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
    ln -s ${service}/bin/clash-verge-service $out/bin/clash-verge-service
    ln -s ${lib.getExe mihomo} $out/bin/verge-mihomo
    ln -s ${v2ray-geoip}/share/v2ray/geoip.dat $out/lib/Clash\ Verge/resources/geoip.dat
    ln -s ${v2ray-rules-dat}/share/v2ray/geosite.dat $out/lib/Clash\ Verge/resources/geosite.dat
    ln -s ${dbip-asn-lite.mmdb} $out/lib/Clash\ Verge/resources/ASN.mmdb
    ln -s ${dbip-country-lite.mmdb} $out/lib/Clash\ Verge/resources/Country.mmdb

    runHook postInstall
  '';
  # For testing convenience
  passthru = { inherit unwrapped service; };
}
